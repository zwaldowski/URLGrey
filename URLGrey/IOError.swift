//
//  IOError.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 1/10/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import Lustre

// MARK: I/O Errors

/// An I/O operation failed.
public enum IOError: ErrorType {
    
    // An unknown error occured.
    case Unknown
    /// A write error occured.
    case Write
    /// A read error occured.
    case Read
    /// An attempt was made to perform I/O on a closed stream.
    case Closed
    /// Cancelled by user.
    case UserCancelled
    /// For a Data<T> instance, the given data was too small for the
    /// parameterized bit type.
    case PartialData
    
}
