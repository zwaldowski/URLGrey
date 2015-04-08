//
//  NSURL+Resource.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 10/21/14.
//  Copyright (c) 2014 Zachary Waldowski. All rights reserved.
//

import Foundation
import Lustre

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
    func value<Result>(forResource resource: ReadableResource<Result>) -> Result {
        let key = resource.key
        
        var value: AnyObject?
        var fetchError: NSError?
        if !getResourceValue(&value, forKey: key, error: &fetchError) {
            return failure(error(code: URLError.ResourceRead(key), underlying: fetchError))
        }
        return resource.read(value)
    }
    
    /**
        Attempts to write the given value for a specified resource to the
        backing store.
    
        This function synchronously writes the new resource value out to disk.
    
        :param: value The value for the resource property defined by `resource`.
        :param: resource One of the URL’s resource keys.
        :returns: A result type appropriate for an empty data set.
    **/
    func setValue<V>(value: V, forResource resource: WritableResource<V>) -> VoidResult {
        let key = resource.key
        return resource.write(value) >>== { obj in
            return try(makeError: {
                error(code: URLError.ResourceWrite(key), underlying: $0)
                }) {
                    setResourceValue(obj, forKey: key, error: $0)
            }
        }
    }

    // MARK: Grouped convenience

    /// Returns values for the given resources based on the given URLs.
    static func values<Result>(forResource resource: ReadableResource<Result>, URLs urls: NSURL...) -> AnyResult<[Result.Value]> {
        var results: [Result.Value] = []
        results.reserveCapacity(urls.count)
        for url in urls {
            let nextResult = url.value(forResource: resource)
            if nextResult.isSuccess {
                results.append(nextResult.value)
            } else {
                return failure(nextResult.error!)
            }
        }
        return success(results)
    }
    
}
