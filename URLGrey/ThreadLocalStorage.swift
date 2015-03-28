//
//  ThreadLocalStorage.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 3/27/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import Foundation
import URLGreyPrivate

final class ThreadLocalStorage<T: AnyObject> {
    
    private let key: pthread_key_t
    
    init() {
        key = URLGreyCreateKeyForObject()
    }
    
    deinit {
        value = nil
        pthread_key_delete(key)
    }
    
    func getValue(@autoclosure initializer:  () -> T) -> T {
        if let existing = value {
            return existing
        }
        
        let ret = initializer()
        value = ret
        return ret
    }
    
    private var value: T? {
        get {
            let ptr = pthread_getspecific(key)
            if ptr == nil { return nil }
            
            let object = Unmanaged<T>.fromOpaque(COpaquePointer(ptr))
            return object.takeUnretainedValue()
        }
        set {
            let old = pthread_getspecific(key)
            
            if let new = newValue {
                let ptr = Unmanaged.passRetained(new)
                pthread_setspecific(key, UnsafePointer(ptr.toOpaque()))
            } else {
                pthread_setspecific(key, nil)
            }
            
            if old != nil {
                let oldObject = Unmanaged<T>.fromOpaque(COpaquePointer(old))
                return oldObject.release()
            }
        }
    }
    
}
