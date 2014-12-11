//
//  NSURL+Resource.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 10/21/14.
//  Copyright (c) 2014 Zachary Waldowski. All rights reserved.
//

import Foundation
import LlamaKit

public extension NSURL {
    
    private func noValueError(#key: String) -> NSError {
        return error(code: URLGreyError.InvalidResourceValue, description: "Retrieving a value for \(key) on \(self) succeeded, but the value was invalid.")
    }
    
    public func getResourceValue<K, V where K: ReadableResource, V == K.ValueType>(forKey key: K) -> Result<V> {
        var value: AnyObject?
        var error: NSError?
        if (getResourceValue(&value, forKey: key.key, error: &error)) {
            if let inValue = value as? K.InputType {
                if let ret = key.read(inValue) {
                    return success(ret)
                }
            }
            return failure(noValueError(key: key.key))
        } else {
            return failure(error!)
        }
    }
    
    public func setResourceValue<K, V where K: WritableResource, V == K.ValueType>(value: V?, forKey key: K) -> Result<()> {
        var error: NSError?
        var finalValue: AnyObject?
        
        if let value = value {
            let reverseTransformed = key.write(value) as K.OriginalType?
            finalValue = reverseTransformed as AnyObject?
        }
        
        if self.setResourceValue(finalValue, forKey: key.key, error: &error) {
            return success()
        } else {
            return failure(error!)
        }
    }
    
}
