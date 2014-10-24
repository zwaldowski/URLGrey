//
//  NSURL+Resource.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 10/21/14.
//  Copyright (c) 2014 Zachary Waldowski. All rights reserved.
//

import Foundation

public extension NSURL {
    
    public func getResourceValue<K, V where K: ReadableResource, V == K.ValueType>(forKey key: K) -> Result<V> {
        var value: AnyObject?
        var error: NSError?
        if (getResourceValue(&value, forKey: key.key, error: &error)) {
            if let inValue = value as? K.InputType {
                if let ret = key.read(inValue) {
                    return .Success(Box(ret))
                }
            }
            return .None
        } else {
            return .Failure(error!)
        }
    }
    
    public func setResourceValue<K, V where K: WritableResource, V == K.ValueType>(value: V?, forKey key: K) -> Result<Void> {
        var error: NSError?
        var finalValue: AnyObject?
        
        if let value = value {
            let reverseTransformed = key.write(value) as K.OriginalType?
            finalValue = reverseTransformed as AnyObject?
        }
        
        if self.setResourceValue(finalValue, forKey: key.key, error: &error) {
            return .Success(Box())
        } else {
            return .Failure(error!)
        }
    }
    
}
