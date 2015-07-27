//
//  Data+CollectionType.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 2/7/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import Dispatch

public enum UnsafeBufferOwnership<T> {
    case Copy
    case Free
    case Unmap
    case Custom(UnsafeMutableBufferPointer<T> -> ())
}

extension Data {
    
    public init(unsafeWithBuffer buffer: UnsafeMutableBufferPointer<T>, queue: dispatch_queue_t = dispatch_get_global_queue(0, 0), behavior: UnsafeBufferOwnership<T>) {
        let baseAddress = UnsafePointer<Void>(buffer.baseAddress)
        let bytes = buffer.count * sizeof(T)
        let destructor: dispatch_block_t? = {
            switch behavior {
            case .Copy: return nil
            case .Free: return _dispatch_data_destructor_free
            case .Unmap: return _dispatch_data_destructor_munmap
            case .Custom(let fn): return { fn(buffer) }
            }
        }()
        
        self.init(dispatch_data_create(baseAddress, bytes, queue, destructor))
    }
    
    private init<Owner: CollectionType>(unsafeWithOwnedPointer pointer: UnsafePointer<T>, count: Int, queue: dispatch_queue_t = dispatch_get_global_queue(0, 0), owner: Owner) {
        let buffer = UnsafeMutableBufferPointer<T>(start: UnsafeMutablePointer(pointer), count: count)
        self.init(unsafeWithBuffer: buffer, queue: queue, behavior: .Custom({ _ in
            _ = owner
        }))
    }
    
    public init(var array: [T]) {
        self.init(unsafeWithOwnedPointer: &array, count: array.count, owner: array)
    }
    
}
