//
//  Data+CollectionType.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 2/7/15.
//  Copyright © 2014-2015. Some rights reserved.
//

import Dispatch

public enum UnsafeBufferOwnership<T> {
    case Copy
    case Free
    case Unmap
    case Custom(UnsafeBufferPointer<T> -> ())
}

extension Data {
    
    private init(unsafeWithBuffer buffer: UnsafeBufferPointer<T>, queue: dispatch_queue_t, destructor: dispatch_block_t!) {
        let baseAddress = UnsafePointer<Void>(buffer.baseAddress)
        let bytes = buffer.count * sizeof(T)
        self.init(unsafe: dispatch_data_create(baseAddress, bytes, queue, destructor))
    }
    
    private init<Owner: CollectionType>(unsafeWithBuffer buffer: UnsafeBufferPointer<T>, queue: dispatch_queue_t = dispatch_get_global_queue(0, 0), owner: Owner) {
        self.init(unsafeWithBuffer: buffer, queue: queue, destructor: { _ = owner })
    }
    
    public init(unsafeWithBuffer buffer: UnsafeBufferPointer<T>, queue: dispatch_queue_t = dispatch_get_global_queue(0, 0), behavior: UnsafeBufferOwnership<T>) {
        self.init(unsafeWithBuffer: buffer, queue: queue, destructor: {
            switch behavior {
            case .Copy: return nil
            case .Free: return _dispatch_data_destructor_free
            case .Unmap: return _dispatch_data_destructor_munmap
            case .Custom(let fn): return { fn(buffer) }
            }
        }())
    }
    
    public init(array: [T]) {
        let buffer = array.withUnsafeBufferPointer { $0 }
        self.init(unsafeWithBuffer: buffer, owner: array)
    }
    
    public init(array: ContiguousArray<T>) {
        let buffer = array.withUnsafeBufferPointer { $0 }
        self.init(unsafeWithBuffer: buffer, owner: array)
    }
    
}
