//
//  Resource.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 10/21/14.
//  Copyright (c) 2014 Zachary Waldowski. All rights reserved.
//

import Lustre

public protocol _ResourceReadable {
    var key: String { get }
}

// MARK: ResourceReadable

public protocol ResourceReadable: _ResourceReadable {
    typealias ReadResult: ResultType
    
    func read(_: AnyObject?) -> ReadResult
}

// MARK: ResourceWritable

public protocol ResourceWritable: ResourceReadable {
    typealias InputValue
    
    func write(_: InputValue) -> ObjectResult<AnyObject>
}

// MARK: ResourceReadableConvertible

public protocol ResourceReadableConvertible {
    typealias ResourceValue
    
    init?(URLResource: ResourceValue)
}

// MARK: ResourceWritableConvertible

public protocol ResourceWritableConvertible: ResourceReadableConvertible {
    typealias ResourceObjectValue: AnyObject
    
    var URLResourceValue: ResourceObjectValue? { get }
}
