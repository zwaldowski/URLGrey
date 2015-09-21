//
//  NSURL+Resource.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 10/21/14.
//  Copyright © 2014-2015. Some rights reserved.
//

import Foundation

// MARK: Resource Manipulation

public extension NSURL {
    
    /**
        Attempts to fetch the value of the resource for the specified prototype.
    
        This function first checks if the URL already caches the resource value.
        If so, it continues with the cached resource value. If not, the resource
        value is synchronously obtained from the backing store, adding the
        resource value to the URL's cache. The function then attempts to parse
        the resource value.
        
        :param: resource One of the URL’s resource keys.
        :returns: A result type appropriate for the resource's value type.
    **/
    func valueForResource<Prototype: URLResourceReadable>(resource: Prototype) throws -> Prototype.Value {
        var object: AnyObject?
        try getResourceValue(&object, forKey: resource.key)
        return try resource.convertFromInput(object)
    }
    
    /**
        Attempts to write the given value for a specified resource to the
        backing store.
    
        This function synchronously writes the new resource value out to disk.
    
        :param: value The value for the resource property defined by `resource`.
        :param: resource One of the URL’s resource keys.
        :returns: A result type appropriate for an empty data set.
    **/
    func setValue<Prototype: URLResourceWritable>(value: Prototype.Value, forResource resource: Prototype) throws {
        let object = resource.convertToOutput(value)
        try setResourceValue(object, forKey: resource.key)
    }
    
}
