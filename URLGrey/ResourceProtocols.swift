//
//  Resource.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 10/21/14.
//  Copyright (c) 2014 Zachary Waldowski. All rights reserved.
//

import Foundation

// MARK: ReadableResource

public protocol ReadableResource {
    typealias OriginalType: AnyObject
    typealias InputType
    typealias ValueType
    
    var key: String { get }
    var read: (InputType -> ValueType?) { get }
}

// MARK: WritableResource

public protocol WritableResource: ReadableResource {
    var write: (ValueType -> InputType!) { get }
}

// MARK: ReadableResourceConvertible

public protocol ReadableResourceConvertible {
    typealias ReadableResourceType
    
    init?(URLResource: ReadableResourceType)
}

// MARK: WritableResourceConvertible

public protocol WritableResourceConvertible: ReadableResourceConvertible {
    var resourceValue: ReadableResourceType! { get }
}
