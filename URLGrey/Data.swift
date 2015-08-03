//
//  Data.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 2/7/15.
//  Copyright © 2014-2015. Some rights reserved.
//

import Dispatch

/// A read-only construct that conceptually models a buffer of numeric units.
public struct Data<T: UnsignedIntegerType> {
    
    public let data: dispatch_data_t
    
    init(unsafe data: dispatch_data_t) {
        self.data = data
    }
    
    init(safe data: dispatch_data_t, @noescape withPartialData: Data<UInt8> throws -> ()) rethrows {
        let size = dispatch_data_get_size(data)
        let remainder = size % sizeof(T)
        if remainder == 0 {
            self.init(unsafe: data)
        } else {
            let wholeData = dispatch_data_create_subrange(data, 0, size - remainder)
            let partialData = dispatch_data_create_subrange(data, size - remainder, remainder)
            let partial = Data<UInt8>(unsafe: partialData)
            try withPartialData(partial)
            self.init(unsafe: wholeData)
        }
    }
    
    public init(_ data: dispatch_data_t, inout partial: Data<UInt8>?) {
        try! self.init(safe: data) { data in
            partial += data
        }
    }
    
    public init() {
        self.init(unsafe: dispatch_data_empty)
    }
    
    public init(_ data: dispatch_data_t) throws {
        try self.init(safe: data) { _ in
            throw IOError.PartialData
        }
    }
    
}

// MARK: Internal

extension Data {
    
    static func toBytes(i: Int) -> Int {
        return i / sizeof(T)
    }
    
    static func fromBytes(i: Int) -> Int {
        return i * sizeof(T)
    }
    
    private typealias Bytes = UnsafeBufferPointer<UInt8>
    
    private var startByte: Int {
        return 0
    }
    
    private var endByte: Int {
        return dispatch_data_get_size(data)
    }
    
    private func apply(function: (data: dispatch_data_t, range: HalfOpenInterval<Int>, buffer: Bytes) -> Bool) {
        dispatch_data_apply(data) { (data, offset, ptr, count) -> Bool in
            let buffer = Bytes(start: UnsafePointer(ptr), count: count)
            return function(data: data, range: offset..<offset+count, buffer: buffer)
        }
    }
    
    private func byteRangeForIndex(i: Int) -> HalfOpenInterval<Int> {
        let byteStart = Data.fromBytes(i)
        let byteEnd = byteStart + sizeof(T)
        return byteStart ..< byteEnd
    }
    
}

// MARK: Collection conformances

extension Data: SequenceType {
    
    public var byteRegions: DataRegions {
        return DataRegions(data: data)
    }
    
    public func generate() -> DataGenerator<T> {
        return DataGenerator(regions: byteRegions.generate())
    }
    
}

extension Data: Indexable {
    
    public var startIndex: Int {
        return Data.toBytes(startByte)
    }
    
    public var endIndex: Int {
        return Data.toBytes(endByte)
    }
    
    public subscript(i: Int) -> T {
        let byteRange = byteRangeForIndex(i)
        assert(byteRange.end < endByte, "Data index out of range")
        
        var ret = T.allZeros
        withUnsafeMutablePointer(&ret) { retPtrIn -> () in
            var retPtr = UnsafeMutablePointer<UInt8>(retPtrIn)
            apply { (_, chunkRange, buffer) -> Bool in
                let copyRange = chunkRange.clamp(byteRange)
                if !copyRange.isEmpty {
                    let size = copyRange.end - copyRange.start
                    memmove(retPtr, buffer.baseAddress + copyRange.start, size)
                    retPtr += size
                }
                return chunkRange.end < byteRange.end
            }
        }
        return ret
    }
    
}

extension Data: CollectionType {
    
    public subscript (bounds: Range<Int>) -> Data<T> {
        let offset = Data.toBytes(bounds.startIndex)
        let length = Data.toBytes(bounds.endIndex - bounds.startIndex)
        return Data(unsafe: dispatch_data_create_subrange(data, offset, length))
    }
    
}

// MARK: Concatenation

extension Data {
    
    public mutating func extend(newData: Data<T>) {
        self += newData
    }
    
}

public func +<T: UnsignedIntegerType>(lhs: Data<T>, rhs: Data<T>) -> Data<T> {
    return Data(unsafe: dispatch_data_create_concat(lhs.data, rhs.data))
}

public func +=<T: UnsignedIntegerType>(inout lhs: Data<T>, rhs: Data<T>) {
    lhs = lhs + rhs
}

public func +=<T: UnsignedIntegerType>(inout lhs: Data<T>?, rhs: Data<T>) {
    if let currentData = lhs {
        lhs = currentData + rhs
    } else {
        lhs = rhs
    }
}

// MARK: Mapped access

extension Data {
    
    public func withUnsafeBufferPointer<R>(@noescape body: UnsafeBufferPointer<T> -> R) -> R {
        var ptr: UnsafePointer<Void> = nil
        var byteCount = 0
        let map = dispatch_data_create_map(data, &ptr, &byteCount)
        let count = Data.fromBytes(byteCount)
        return withExtendedLifetime(map) {
            let buffer = UnsafeBufferPointer<T>(start: UnsafePointer(ptr), count: count)
            return body(buffer)
        }
    }
    
}

// MARK: Generators

public struct DataRegions: SequenceType {
    
    private let data: dispatch_data_t
    
    private init(data: dispatch_data_t) {
        self.data = data
    }
    
    public func generate() -> DataRegionsGenerator {
        return DataRegionsGenerator(data: data)
    }
    
}

public struct DataRegionsGenerator: GeneratorType, SequenceType {
    
    private let data: dispatch_data_t
    private var region = dispatch_data_empty
    private var nextByteOffset = 0
    
    public init(data: dispatch_data_t) {
        self.data = data
    }
    
    public mutating func next() -> UnsafeBufferPointer<UInt8>? {
        if nextByteOffset >= dispatch_data_get_size(data) {
            return nil
        }
        
        let nextRegion = dispatch_data_copy_region(data, nextByteOffset, &nextByteOffset)
        
        // This won't remap the buffer because the region will be a leaf,
        // so it just returns the buffer
        var mapPtr = UnsafePointer<Void>()
        var mapSize = 0
        region = dispatch_data_create_map(nextRegion, &mapPtr, &mapSize)
        nextByteOffset += mapSize
        
        return UnsafeBufferPointer(start: UnsafePointer(mapPtr), count: mapSize)
    }
    
    public func generate() -> DataRegionsGenerator {
        return DataRegionsGenerator(data: data)
    }
    
}

public struct DataGenerator<T: UnsignedIntegerType>: GeneratorType, SequenceType {
    
    private var regions: DataRegionsGenerator
    private var buffer: UnsafeBufferPointerGenerator<UInt8>?
    
    private init(regions: DataRegionsGenerator) {
        self.regions = regions
    }
    
    private mutating func nextByte() -> UInt8? {
        // continue through existing region
        if let next = buffer?.next() { return next }
        
        // get next region
        guard let nextRegion = regions.next() else { return nil }
        
        // start generating
        var nextBuffer = nextRegion.generate()
        guard let byte = nextBuffer.next() else {
            buffer = nil
            return nil
        }
        buffer = nextBuffer
        return byte
    }
    
    public mutating func next() -> T? {
        return (0 ..< sizeof(T)).reduce(T.allZeros) { (current, byteIdx) -> T? in
            guard let current = current, byte = nextByte() else { return nil }
            return current | numericCast(byte << UInt8(byteIdx * 8))
        }
    }
    
    public func generate() -> DataGenerator<T> {
        return DataGenerator(regions: regions.generate())
    }
    
}

// MARK: AnyObject bridging

extension Data: _ObjectiveCBridgeable {
    
    public typealias _ObjectiveCType = dispatch_data_t
    
    public static func _isBridgedToObjectiveC() -> Bool {
        return true
    }
    
    public func _bridgeToObjectiveC() -> dispatch_data_t {
        return data
    }
    
    public static func _getObjectiveCType() -> Any.Type {
        return dispatch_data_t.self
    }
    
    public static func _forceBridgeFromObjectiveC(source: dispatch_data_t, inout result: Data?) {
        result = try! Data(source)
    }
    
    public static func _conditionallyBridgeFromObjectiveC(source: dispatch_data_t, inout result: Data?) -> Bool {
        do {
            result = try Data(source)
            return true
        } catch {
            result = nil
            return false
        }
    }
    
}
