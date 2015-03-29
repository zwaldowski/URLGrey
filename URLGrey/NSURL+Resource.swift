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
    
    func value<K: ResourceReadable, R: ResultType where K.ReadResult == R>(forResource resource: K) -> R {
        let key = resource.key
        
        var value: AnyObject?
        var fetchError: NSError?
        if !getResourceValue(&value, forKey: key, error: &fetchError) {
            return failure(error(code: URLError.ResourceRead(key), underlying: fetchError))
        }
        return resource.read(value)
    }
    
    func setValue<K: ResourceWritable, V where K.InputValue == V>(value: V, forResource resource: K) -> VoidResult {
        let key = resource.key

        return flatMap(resource.write(value)) { finalValue -> VoidResult in
            var saveError: NSError?
            if !self.setResourceValue(finalValue, forKey: key, error: &saveError) {
                return failure(error(code: URLError.ResourceWrite(key), underlying: saveError))
            }
            return success()
        }
    }

    // MARK: Grouped convenience
    
    static func values<K: ResourceReadable, R: ResultType where K.ReadResult == R>(forResource resource: K, URLs urls: NSURL...) -> AnyResult<[R.Value]> {
        var results: [R.Value] = []
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
