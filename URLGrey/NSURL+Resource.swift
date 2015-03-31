//
//  NSURL+Resource.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 10/21/14.
//  Copyright (c) 2014 Zachary Waldowski. All rights reserved.
//

import Foundation
import Lustre

public extension NSURL {
    
    func value<K: ResourceReadable>(forResource resource: K) -> K.ReadResult {
        let key = resource.key
        
        var value: AnyObject?
        var fetchError: NSError?
        if !getResourceValue(&value, forKey: key, error: &fetchError) {
            return failure(error(code: URLError.ResourceRead(key), underlying: fetchError))
        }
        return resource.read(value)
    }
    
    func setValue<K: ResourceWritable>(value: K.InputValue, forResource resource: K) -> VoidResult {
        let key = resource.key
        return resource.write(value) >>== { obj in
            return try(makeError: makeError(URLError.ResourceWrite(key))) {
                let toNull: AnyObject? = (obj !== NSNull()) ? obj : nil
                return setResourceValue(toNull, forKey: key, error: $0)
            }
        }
    }

    // MARK: Grouped convenience
    
    static func values<K: ResourceReadable>(forResource resource: K, URLs urls: NSURL...) -> AnyResult<[K.ReadResult.Value]> {
        var results: [K.ReadResult.Value] = []
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
