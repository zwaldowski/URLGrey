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
    
    public func getResourceValue<K, V where K: ReadableResource, V == K.ValueType>(forKey key: K) -> Result<V> {
        var value: AnyObject?
        var fetchError: NSError?
        if (getResourceValue(&value, forKey: key.stringValue, error: &fetchError)) {
            if let inValue = value as? K.InputType {
                if let ret = key.read(inValue) {
                    return success(ret)
                }
            }
            return failure(error(code: URLGreyError.InvalidResourceValue(key.stringValue)))
        } else {
            return failure(fetchError!)
        }
    }
    
    public func setResourceValue<K, V where K: WritableResource, V == K.ValueType, K.OriginalType: AnyObject>(value: V?, forKey key: K) -> Result<()> {
        var error: NSError?
        var finalValue: AnyObject?
        
        if let value = value {
            finalValue = key.write(value) as? K.OriginalType
        }
        
        if self.setResourceValue(finalValue, forKey: key.stringValue, error: &error) {
            return success()
        } else {
            return failure(error!)
        }
    }
    
}
