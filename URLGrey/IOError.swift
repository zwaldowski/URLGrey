//
//  IOError.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 1/10/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

// MARK: I/O Errors

/// An I/O operation failed.
public enum IOError: ErrorType {
    
    /// An unknown POSIX error occurred in the system framework.
    case Unknown
    /// An attempt was made to perform I/O on a closed stream.
    case Closed
    /// An I/O operation was cancelled by the user.
    case UserCancelled
    /// For a Data<T> instance, the given data was too small for the
    /// parameterized bit type.
    case PartialData
    
}
