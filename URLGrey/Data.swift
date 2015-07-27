//
//  Data.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 1/5/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import Dispatch

/// A read-only construct that conceptually models a buffer of bytes.
public struct Data {
    
    public typealias Buffer = UnsafeBufferPointer<UInt8>
    private typealias Pointer = UnsafePointer<UInt8>
    private typealias BufferPairs = [(dispatch_data_t, Buffer)]
    
    var data: dispatch_data_t
    
    public init() {
        self.init(dispatch_data_empty)
    }
    
    public init(_ data: dispatch_data_t) {
        self.data = data
    }
    
    public var isEmpty: Bool {
        return count == 0
    }
    
    public var count: Int {
        return Int(dispatch_data_get_size(data))
    }
    
}

extension Data {
    
    public init<T>(var array: [T]) {
        self.init(unsafeWithOwnedPointer: &array, count: array.count, owner: array)
    }
    
    public init<T>(var slice: ArraySlice<T>) {
        self.init(unsafeWithOwnedPointer: &slice, count: slice.count, owner: slice)
    }
    
    public init<T>(var array: ContiguousArray<T>) {
        self.init(unsafeWithOwnedPointer: &array, count: array.count, owner: array)
    }
    
    public enum UnsafeOwnership {
        case Copy
        case Free
        case Unmap
    }
    
    private init<T, Owner>(unsafeWithOwnedPointer pointer: UnsafePointer<T>, count tCount: Int, queue: dispatch_queue_t = dispatch_get_global_queue(0, 0), owner: Owner) {
        let count = sizeof(T) * tCount
        self.init(dispatch_data_create(pointer, count, queue) { _ = owner })
    }
    
    private init<T>(unsafeWithPointer pointer: UnsafePointer<T>, count tCount: Int, queue: dispatch_queue_t = dispatch_get_global_queue(0, 0), behavior: UnsafeOwnership = .Copy) {
        let count = sizeof(T) * tCount
        let destructor: (() -> ())? = {
            switch behavior {
            case .Copy: return nil
            case .Free: return _dispatch_data_destructor_free
            case .Unmap: return _dispatch_data_destructor_munmap
            }
        }()
        self.init(dispatch_data_create(pointer, count, queue, destructor))
    }
    
    private func apply(function: (data: dispatch_data_t, range: HalfOpenInterval<Int>, buffer: Buffer) -> Bool) {
        dispatch_data_apply(data) { (data, cOffset, cPointer, cCount) -> Bool in
            let offset = Int(cOffset)
            let count = Int(cCount)
            let buffer = Buffer(start: Pointer(cPointer), count: count)
            return function(data: data, range: offset..<offset+count, buffer: buffer)
        }
    }
    
    public func apply<T>(function: (range: HalfOpenInterval<Int>, buffer: Buffer) -> T?) -> T? {
        var ret: T?
        apply { _, range, buffer -> Bool in
            if let value = function(range: range, buffer: buffer) {
                ret = value
                return false
            } else {
                return true
            }
        }
        return ret
    }
    
    public func region(index index: Int) -> (data: Data, range: Range<Int>) {
        var offset = 0
        let region = Data(dispatch_data_copy_region(data, index, &offset))
        let range = Range(start: offset, end: offset + region.endIndex)
        return (region, range)
    }
    
    func withUnsafeBufferPointer<R>(body: Buffer -> R) -> R {
        var ptr: UnsafePointer<Void> = nil
        var count = 0
        let map = dispatch_data_create_map(data, &ptr, &count)
        return withExtendedLifetime(map) { (_: dispatch_data_t) -> R in
            let buffer = Buffer(start: Pointer(ptr), count: count)
            return body(buffer)
        }
    }
    
    func withMappedSubrange<R>(bounds: Range<Int>, body: Buffer -> R) -> R? {
        let count = bounds.endIndex - bounds.startIndex
        let subrange = self[bounds]
        return subrange.count == count ? subrange.withUnsafeBufferPointer(body) : nil
    }

}

extension Data: SequenceType {
    
    private var buffersArray: BufferPairs {
        var buffers = BufferPairs()
        apply { (data, _, buffer) -> Bool in
            buffers.append(data, buffer)
            return true
        }
        return buffers
    }
    
    public func generate() -> DataGenerator {
        return DataGenerator(buffers: buffersArray)
    }
    
    public func buffers() -> AnySequence<Buffer> {
        return AnySequence(lazy(buffersArray).map { $0.1 })
    }
    
}

extension Data: CollectionType {
    
    public var startIndex: Int {
        return 0
    }
    
    public var endIndex: Int {
        return count
    }
    
    public subscript (index: Int) -> UInt8 {
        return apply { range, buffer in
            if range.contains(index) {
                let local = Int(index - range.start)
                return buffer[local]
            }
            return nil
        }!
    }
    
    public typealias SubSlice = Data

    public subscript (bounds: Range<Int>) -> SubSlice {
        let offset = bounds.startIndex
        let length = bounds.endIndex - bounds.startIndex
        return Data(dispatch_data_create_subrange(data, offset, length))
    }
    
    
    public mutating func append(newData: Data) {
        data = dispatch_data_create_concat(data, newData.data)
    }
    
}

// MARK: DataGenerator

public struct DataGenerator: GeneratorType, SequenceType {
    
    private typealias BufferPairs = Data.BufferPairs
    private var buffersGenerator: IndexingGenerator<BufferPairs>
    private var currentGenerator: Data.Buffer.Generator?
    
    private init(buffersGenerator: BufferPairs.Generator) {
        self.buffersGenerator = buffersGenerator
    }
    
    private init(buffers: BufferPairs) {
        self.init(buffersGenerator: buffers.generate())
    }
    
    public mutating func next() -> UInt8? {
        if let currentEl = currentGenerator?.next() {
            return currentEl
        }
        
        currentGenerator = buffersGenerator.next()?.1.generate()
        return currentGenerator?.next()
    }
    
    public func generate() -> DataGenerator {
        return DataGenerator(buffersGenerator: buffersGenerator.generate())
    }
    
}

// MARK: Operators

public func +(lhs: Data, rhs: Data) -> Data {
    return Data(dispatch_data_create_concat(lhs.data, rhs.data))
}

public func +=(inout lhs: Data, rhs: Data) {
    lhs.append(rhs)
}
