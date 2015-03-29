//
//  Resource.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 10/21/14.
//  Copyright (c) 2014 Zachary Waldowski. All rights reserved.
//

import Lustre


/// Common protocol for any file resource
public protocol ResourceType {
    var key: String { get }
}

// MARK: ResourceReadable

/// Common protocol for any resource that can be read
public protocol ResourceReadable: ResourceType {
    typealias ReadResult: ResultType
    
    func read(_: AnyObject?) -> ReadResult
}

// MARK: ResourceWritable

/// Common protocol for any resource that can be written
public protocol ResourceWritable: ResourceReadable {
    typealias InputValue
    
    func write(_: InputValue) -> ObjectResult<AnyObject>
}

// MARK: ResourceReadableConvertible

/// Protocol for custom resource types further refined from Cocoa resources
public protocol ResourceReadableConvertible {
    typealias ResourceValue: _ObjectiveCBridgeable
    
    init?(URLResource: ResourceValue)
}

// MARK: ResourceWritableConvertible

/// Protocol for custom resource types to be converted back to Cocoa types
public protocol ResourceWritableConvertible: ResourceReadableConvertible {
    typealias ResourceObjectValue: AnyObject
    
    var URLResourceValue: ResourceObjectValue? { get }
}
