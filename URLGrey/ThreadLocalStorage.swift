//
//  ThreadLocalStorage.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 3/27/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

final class ThreadLocalStorage<T: AnyObject> {
    
    private let key = URLGreyCreateKeyForObject()
    private let mainThreadFallback: (() -> T)?
    
    init(mainThreadFallback initializer: (() -> T)? = nil) {
        self.mainThreadFallback = initializer
    }
    
    deinit {
        let valuePtr = pthread_getspecific(key)
        if valuePtr != nil {
            let object = Unmanaged<T>.fromOpaque(COpaquePointer(valuePtr))
            return object.release()
        }
        pthread_key_delete(key)
    }
    
    func getValue(@autoclosure create initializer: () -> T) -> T {
        if let mainVersion = mainThreadFallback where NSThread.isMainThread() {
            return mainVersion()
        }
        
        let ptr = pthread_getspecific(key)
        if ptr == nil {
            let ret = initializer()
            let ptr = Unmanaged.passRetained(ret)
            pthread_setspecific(key, UnsafePointer(ptr.toOpaque()))
            return ret
        }
        
        return Unmanaged.fromOpaque(COpaquePointer(ptr)).takeUnretainedValue()
    }
        
}
