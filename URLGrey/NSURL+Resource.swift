//
//  NSURL+Resource.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 10/21/14.
//  Copyright (c) 2014 Zachary Waldowski. All rights reserved.
//

import Foundation

public extension NSURL {
    
    public func getResourceValue<K, V where K: ReadableResource, V == K.OutType>(forKey key: K) -> Result<V> {
        var value: AnyObject?
        var error: NSError?
        if (getResourceValue(&value, forKey: key.key, error: &error)) {
            if let inValue = value as? K.InType {
                if let ret = key.read(inValue) {
                    return .Success(Box(ret))
                }
            }
            return .None
        } else {
            return .Failure(error!)
        }
    }
    
}
