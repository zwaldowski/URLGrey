//
//  Result.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 10/21/14.
//  Copyright (c) 2014 Zachary Waldowski. All rights reserved.
//

import Foundation

enum Result<T> {
    case None
    case Success(Box<T>)
    case Failure(NSError)
    
    var value: T? {
        switch self {
        case Success(let boxed): return boxed.value
        default: return nil
        }
    }
    
    func map<U>(transform: T -> U) -> Result<U> {
        switch self {
        case Success(let box):
            return .Success(Box(transform(box.value)))
        case Failure(let err):
            return .Failure(err)
        default:
            return .None
        }
    }
    
    func map(defaultValue failure: @autoclosure () -> T) -> T {
        switch self {
        case Success(let box):
            return box.value
        default:
            return failure()
        }
    }
    
    func map<U>(defaultValue failure: @autoclosure () -> U, transform success: T -> U) -> U {
        switch self {
        case Success(let box):
            return success(box.value)
        default:
            return failure()
        }
    }
}
