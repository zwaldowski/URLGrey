//
//  URLResourceMeta.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 10/21/14.
//  Copyright © 2014-2015. Some rights reserved.
//

import Foundation

// MARK: Custom type conversion

public protocol URLResourceConvertible {
    
    /// A resource-readable type must be created with a Cocoa-compatible
    /// object or bridged type.
    typealias Source: _ObjectiveCBridgeable
    
    /// Attempt to create an instance from a given Cocoa-compatible type.
    init(URLResource: Source) throws
    
}

public protocol URLResourceRepresentable: URLResourceConvertible {
    
    /// A Cocoa-compatible representation of the value.
    typealias Output: AnyObject
    
    /// Attempt to turn the represented value into a Cocoa-compatible type.
    var URLResourceValue: Output { get }
    
}

// MARK: Resource metatypes

/// A common protocol representing any any item resource.
public protocol URLResourceType {
    
    /// A string key describing how to access this resource via Foundation API.
    var key: String { get }
    
}

/// Prototypes for resources that may be fetched from URLs.
public protocol URLResourceReadable: URLResourceType {
    
    /// The native-Swift return type for the resource.
    typealias Value
    
    /// Attempt to parse the object type into a native Swift type.
    func convertFromInput(input: AnyObject) throws -> Value
    
}

public protocol URLResourceWritable: URLResourceReadable {
    
    /// Convert the native Swift type back for Foundation to write.
    func convertToOutput(value: Value) -> AnyObject
    
}

// MARK: Default implementations

extension URLResourceReadable {
    
    func convertFromInput(input: AnyObject?) throws -> Value {
        guard let input: AnyObject = input else {
            throw URLResourceError.NotAvailable
        }
        return try convertFromInput(input)
    }
    
}

// MARK: Common Prototypes

public struct URLResourceBridgedRead<T: _ObjectiveCBridgeable>: URLResourceReadable {
    
    public let key: String
    
    public func convertFromInput(input: AnyObject) throws -> T {
        guard let value = input as? T else {
            throw URLResourceError.CannotRead
        }
        return value
    }
    
}

public struct URLResourceBridgedWrite<T: _ObjectiveCBridgeable>: URLResourceWritable {
    
    public let key: String
    
    public func convertFromInput(input: AnyObject) throws -> T {
        guard let value = input as? T else {
            throw URLResourceError.CannotRead
        }
        return value
    }
    
    public func convertToOutput(value: T) -> AnyObject {
        return value as! AnyObject
    }
    
}

public struct URLResourceObjectRead<T: AnyObject>: URLResourceReadable {
    
    public let key: String
    
    public func convertFromInput(input: AnyObject) throws -> T {
        guard let value = input as? T else {
            throw URLResourceError.CannotRead
        }
        return value
    }
    
}

public struct URLResourceObjectWrite<T: AnyObject>: URLResourceWritable {
    
    public let key: String
    
    public func convertFromInput(input: AnyObject) throws -> T {
        guard let value = input as? T else {
            throw URLResourceError.CannotRead
        }
        return value
    }
    
    public func convertToOutput(value: T) -> AnyObject {
        return value
    }
    
}

public struct URLResourceConvertRead<T: URLResourceConvertible>: URLResourceReadable {
    
    public let key: String
    
    public func convertFromInput(input: AnyObject) throws -> T {
        guard let input = input as? Value.Source else {
            throw URLResourceError.CannotRead
        }
        return try Value(URLResource: input)
    }
    
}

public struct URLResourceConvertWrite<T: URLResourceRepresentable>: URLResourceReadable {
    
    public let key: String
    
    public func convertFromInput(input: AnyObject) throws -> T {
        guard let input = input as? Value.Source else {
            throw URLResourceError.CannotRead
        }
        return try Value(URLResource: input)
    }
    
    public func convertToOutput(value: T) -> AnyObject {
        return value.URLResourceValue
    }
    
}

@available(OSX 10.10, iOS 8.0, watchOS 2.0, *)
public struct URLResourceThumbnails: URLResourceWritable {
    
    public typealias Thumbnails = [ThumbnailSize: ImageType]
    
    public let key = NSURLThumbnailDictionaryKey
    
    public func convertFromInput(input: AnyObject) throws -> Thumbnails {
        guard let dictionary = input as? [String: ImageType] else {
            throw URLResourceError.CannotRead
        }
        
        var ret = [ThumbnailSize: ImageType](minimumCapacity: dictionary.count)
        for (sizeKey, image) in dictionary {
            let key = try ThumbnailSize(URLResource: sizeKey)
            ret[key] = image
        }
        return ret
    }
    
    public func convertToOutput(dictionary: Thumbnails) -> AnyObject {
        var ret = [NSObject: AnyObject](minimumCapacity: dictionary.count)
        for (size, image) in dictionary {
            ret[size.URLResourceValue] = image
        }
        return ret
    }
    
}

public struct URLResourceErrorRead<T: ErrorType>: URLResourceReadable {
    
    public let key: String
    
    public func convertFromInput(input: AnyObject) throws -> T {
        guard let input = input as? T else {
            throw URLResourceError.CannotRead
        }
        return input
    }
    
}
