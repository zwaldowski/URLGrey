//
//  Resource.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 10/21/14.
//  Copyright (c) 2014 Zachary Waldowski. All rights reserved.
//

import Lustre

// MARK: ResourceReadable

public protocol ResourceReadable {
    typealias ReadResult: ResultType
    
    var key: String { get }
    
    func read(_: AnyObject?) -> ReadResult
}

// MARK: ResourceWritable

public protocol ResourceWritable {
    typealias InputValue
    
    var key: String { get }
    
    func write(_: InputValue) -> ObjectResult<AnyObject>
}

// MARK: ResourceReadableConvertible

public protocol ResourceReadableConvertible {
    typealias ResourceValue
    
    init?(URLResource: ResourceValue)
}

// MARK: ResourceWritableConvertible

public protocol ResourceWritableConvertible: ResourceReadableConvertible {
    var URLResourceValue: AnyObject? { get }
}
