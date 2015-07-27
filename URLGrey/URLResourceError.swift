//
//  URLResourceError.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 3/26/15.
//  Copyright © 2014-2015. Some rights reserved.
//

public enum URLResourceError: ErrorType {
    
    /// A resource could not be coerced to the correct value type.
    case CannotRead
    /// A resource is not unimplemented or unavailable at the system level.
    case NotAvailable
    /// A resource value was not contained within the values defined by the system.
    case InvalidValue

}
