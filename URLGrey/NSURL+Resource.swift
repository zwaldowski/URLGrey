//
//  NSURL+Resource.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 10/21/14.
//  Copyright (c) 2014 Zachary Waldowski. All rights reserved.
//

import Foundation

public extension NSURL {
    
    public func getResourceValue<K, V where K: ReadableResource, V == K.ValueType>(forKey key: K) -> AnyResult<V> {
        let keyString = key.stringValue

        var value: AnyObject?
        var fetchError: NSError?
        if (getResourceValue(&value, forKey: keyString, error: &fetchError)) {
            if let inValue = value as? K.InputType {
                if let ret = key.read(inValue) {
                    return success(ret)
                }
            }
            
            return failure(error(code: URLError.InvalidResourceRead(keyString)))
        } else {
            return failure(error(code: URLError.ReadResource(keyString), underlying: fetchError))
        }
    }
    
    public func setResourceValue<K, V where K: WritableResource, V == K.ValueType, K.OriginalType: AnyObject>(value: V?, forKey key: K) -> VoidResult {
        let keyString = key.stringValue
        
        // This is ugly, but `let`-ing it out separately got it mad
        if let finalValue: AnyObject? = value.map({
            key.write($0) as? K.OriginalType
        }) {
            var saveError: NSError?
            if setResourceValue(finalValue, forKey: key.stringValue, error: &saveError) {
                return success()
            } else {
                return failure(error(code: URLError.WriteResource(keyString), underlying: saveError))
            }
        } else {
            return failure(error(code: URLError.InvalidResourceWrite(keyString)))
        }
    }
    
}
