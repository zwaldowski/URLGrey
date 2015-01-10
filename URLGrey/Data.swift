//
//  Data.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 1/5/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import Dispatch

public struct Data {
    
    public typealias Buffer = UnsafeBufferPointer<Byte>
    private typealias Pointer = UnsafePointer<Byte>
    private typealias BufferPairs = [(dispatch_data_t, Buffer)]
    
    private var data: dispatch_data_t
    
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
        self.init(pointer: &array, count: array.count, owner: array)
    }
    
    public init<T>(var slice: Slice<T>) {
        self.init(pointer: &slice, count: slice.count, owner: slice)
    }
    
    public init<T>(var array: ContiguousArray<T>) {
        self.init(pointer: &array, count: array.count, owner: array)
    }
    
    public init<T, Owner>(pointer: UnsafePointer<T>, count tCount: Int, queue: dispatch_queue_t = dispatch_get_global_queue(0, 0), owner: Owner) {
        let count = UInt(sizeof(T) * tCount)
        self.init(dispatch_data_create(pointer, count, queue) { _ = owner })
    }
    
    public enum UnsafeOwnership {
        case Copy
        case Free
        case Unmap
    }
    
    public init<T, Owner>(pointer: UnsafePointer<T>, count tCount: Int, queue: dispatch_queue_t = dispatch_get_global_queue(0, 0), behavior: UnsafeOwnership = .Copy) {
        let count = UInt(sizeof(T) * tCount)
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
    
    public func region(#index: Int) -> (data: Data, range: Range<Int>) {
        var cOffset: UInt = 0
        let region = Data(dispatch_data_copy_region(data, UInt(index), &cOffset))
        let offset = Int(cOffset)
        let range = Range(start: offset, end: offset + region.endIndex)
        return (region, range)
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
    
    public func buffers() -> SequenceOf<Buffer> {
        return SequenceOf(lazy(buffersArray).map { $0.1 })
    }
    
}

extension Data: CollectionType {
    
    public var startIndex: Int {
        return 0
    }
    
    public var endIndex: Int {
        return count
    }
    
    public subscript (index: Int) -> Byte {
        return apply { range, buffer in
            if range.contains(index) {
                let local = Int(index - range.start)
                return buffer[local]
            }
            return nil
        }!
    }
    
}

extension Data: Sliceable {
    
    public typealias SubSlice = Data

    public subscript (bounds: Range<Int>) -> SubSlice {
        let offset = UInt(bounds.startIndex)
        let length = UInt(bounds.endIndex - bounds.startIndex)
        return Data(dispatch_data_create_subrange(data, offset, length))
    }
    
}

extension Data: ByteCollection {
    
    public typealias Element = Byte
    
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
    
    public mutating func next() -> Byte? {
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
