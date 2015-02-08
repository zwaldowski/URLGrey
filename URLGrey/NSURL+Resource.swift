//
//  NSURL+Resource.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 10/21/14.
//  Copyright (c) 2014 Zachary Waldowski. All rights reserved.
//

import Foundation

public extension NSURL {
    
    public func value<K: ResourceReadable, R: ResultType where K.ReadResult == R>(forResource resource: K) -> R {
        let key = resource.key
        
        var value: AnyObject?
        var fetchError: NSError?
        if !getResourceValue(&value, forKey: key, error: &fetchError) {
            return K.ReadResult(failure: error(code: URLError.ResourceRead(key), underlying: fetchError))
        }
        return resource.read(value)
    }
    
    public func setValue<K: ResourceWritable, V where K.InputValue == V>(value: V, forResource resource: K) -> VoidResult {
        let key = resource.key

        return resource.write(value).flatMap { finalValue -> VoidResult in
            var saveError: NSError?
            if !self.setResourceValue(finalValue, forKey: key, error: &saveError) {
                return failure(error(code: URLError.ResourceWrite(key), underlying: saveError))
            }
            return success()
        }
    }
    
}
