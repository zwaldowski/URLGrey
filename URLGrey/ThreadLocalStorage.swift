//
//  ThreadLocalStorage.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 3/27/15.
//  Copyright © 2014-2015. Some rights reserved.
//

import Foundation

struct ThreadLocalStorage<T: AnyObject> {
    
    private let key = String(ThreadLocalStorage<T>.self)
    private let mainThreadFallback: (() -> T)?
    
    init(mainThreadFallback initializer: (() -> T)? = nil) {
        self.mainThreadFallback = initializer
    }
    
    func getValue(@autoclosure create initializer: () -> T) -> T {
        if NSThread.isMainThread(), let mainVersion = mainThreadFallback {
            return mainVersion()
        }
        
        let threadDictionary = NSThread.currentThread().threadDictionary
        
        if let object: AnyObject = threadDictionary[key] {
            return unsafeDowncast(object)
        }
        
        let ret = initializer()
        threadDictionary[key] = ret
        return ret
    }
        
}
