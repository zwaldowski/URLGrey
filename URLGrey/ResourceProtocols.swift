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
    typealias OriginalType
    typealias InputType
    typealias ValueType
    
    var stringValue: String { get }
    func read(_: InputType) -> ValueType?
}

// MARK: WritableResource

public protocol WritableResource: ReadableResource {
    func write(_: ValueType) -> InputType!
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
