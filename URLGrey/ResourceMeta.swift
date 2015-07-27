//
//  ResourceInternal.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 10/21/14.
//  Copyright (c) 2014 Zachary Waldowski. All rights reserved.
//

import Foundation
import Lustre

// MARK: Resource Conversion

/// Protocol for custom resource types to be derived from Cocoa resources
public protocol ResourceConvertible {
    
    /// A resource-readable type must be created with a Cocoa-compatible
    /// object or bridged type.
    typealias ResourceValue: _ObjectiveCBridgeable
    
    /// Attempt to create an instance from a given Cocoa-compatible type.
    init?(URLResource: ResourceValue)
    
}

/// Protocol for custom resource types to be converted back to Cocoa types
public protocol ResourceRepresentable {
    
    /// A resource-writable type must convert to a Cocoa-compatible object.
    typealias ResourceObjectValue: AnyObject
    
    /// Attempt to turn the represented value into a Cocoa-compatible type.
    var URLResourceValue: ResourceObjectValue? { get }
    
}

// MARK: URL Resources

/// A common protocol representing any any item resource.
public protocol ResourceType {
    
    /// A string key describing how to access this resource via Foundation API.
    var key: String { get }
    
}

/// Prototypes for resources that may be fetched from URLs.
public struct ReadableResource<ReadResult: EitherType where ReadResult.LeftType == ErrorType>: ResourceType {
    
    /// A string key describing how to access this resource via Foundation API.
    public let key: String

    private typealias Reader = AnyObject? -> ReadResult
    private let impl: Reader
    
    private init(key: String, impl: Reader) {
        self.key = key
        self.impl = impl
    }
    
    /// Attempt to parse the object type into a native Swift type.
    func read(input: AnyObject?) -> ReadResult {
        return impl(input)
    }
    
    /// Read-only values that can cross the Objective-C bridge (`String`, `Int`)
    static func readable<U: _ObjectiveCBridgeable>(key: String) -> ReadableResource<Result<U>> {
        return ReadableResource<Result<U>>(key: key) {
            switch $0 {
            case .Some(let ret as U):
                return Result.Success(ret)
            case .Some:
                return Result.Failure(URLError.ResourceReadConversion)
            case .None:
                return Result.Failure(URLError.ResourceReadUnavailable)
            }
        }
    }
    
    /// Read-only types that come out exactly as we want them (`NSURL`, `NSDate`)
    static func readableObject<U: AnyObject>(key: String) -> ReadableResource<Result<U>> {
        return ReadableResource<Result<U>>(key: key) {
            switch $0 {
            case .Some(let ret as U):
                return Result.Success(ret)
            case .Some:
                return Result.Failure(URLError.ResourceReadConversion)
            case .None:
                return Result.Failure(URLError.ResourceReadUnavailable)
            }
        }
    }
    
    /// Read-only type that must be converted after being bridged to some native
    /// type (i.e., `String`->`URLGrey.UTI`)
    static func readableConvert<U: ResourceConvertible>(key: String) -> ReadableResource<Result<U>> {
        return ReadableResource<Result<U>>(key: key) {
            switch $0 {
            case .Some(let value):
                if let value = value as? U.ResourceValue, ret = U(URLResource: value) {
                    return Result.Success(ret)
                }
                return Result.Failure(URLError.ResourceReadConversion)
            case .None:
                return Result.Failure(URLError.ResourceReadUnavailable)
            }
        }
    }
    
    /// Read-only values that must undergo arbitrary conversion
    static func readableOf<U: _ObjectiveCBridgeable, V>(key: String, reader: U -> V?) -> ReadableResource<Result<V>> {
        return ReadableResource<Result<V>>(key: key) {
            switch $0 {
            case .Some(let value):
                if let converted = value as? U, ret = reader(converted) {
                    return Result.Success(ret)
                }
                return Result.Failure(URLError.ResourceReadConversion)
            case .None:
                return Result.Failure(URLError.ResourceReadUnavailable)
            }
        }
    }

}

/// Prototypes for resources that may be written to URLs.
public struct WritableResource<T>: ResourceType {
    
    /// A string key describing how to access this resource via Foundation API.
    public let key: String
    
    private typealias Writer = T -> Result<AnyObject>
    private let impl: Writer
    
    private init(key: String, impl: Writer) {
        self.key = key
        self.impl = impl
    }
    
    /// Convert the native Swift type back for Foundation to write.
    func write(input: T) -> Result<AnyObject> {
        return impl(input)
    }
    
    /// Writable values that can cross the Objective-C bridge (`String`, `Int`)
    static func writable<U: _ObjectiveCBridgeable>(key: String) -> WritableResource<U> {
        return WritableResource<U>(key: key) {
            if let ret: AnyObject = $0 as? AnyObject {
                return Result.Success(ret)
            }
            return Result.Failure(URLError.ResourceWriteConversion)
        }
    }
    
    /// Writable values that are already exactly as we want them (`NSDate`)
    static func writableObject<U: AnyObject>(key: String) -> WritableResource<U> {
        return WritableResource<U>(key: key) { Result.Success($0) }
    }
    
    /// Writable values that must be converted before being expressed as a Cocoa type
    static func writableConvert<U: ResourceRepresentable>(key: String) -> WritableResource<U> {
        return WritableResource<U>(key: key) {
            if let ret: AnyObject = $0.URLResourceValue {
                return Result.Success(ret)
            }
            return Result.Failure(URLError.ResourceWriteConversion)
        }
    }
    
    /// Writable values that must undergo arbitrary conversion
    static func writableOf<U, V: AnyObject>(key: String, writer: U -> V) -> WritableResource<U> {
        return WritableResource<U>(key: key) { Result.Success(writer($0)) }
    }
    
}
