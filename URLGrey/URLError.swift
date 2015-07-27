//
//  URLError.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 3/26/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import Lustre

// MARK: URL Resource Errors

/// A URL activity failed.
public enum URLError: ErrorType {
    
    // Retrieving a value for a resource failed.
    case ResourceRead(String)
    /// No values for the given resource were available, i.e., it's unimplemented or unavailable.
    case ResourceReadUnavailable
    /// The value couldn't be coerced to the native type.
    case ResourceReadConversion
    /// The native value couldn't be coerced to the platform type.
    case ResourceWriteConversion
    /// Committing a value to disk failed.
    case ResourceWrite(String)
    
}
