//
//  NSFileManager+DirectoryContents.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 10/23/14.
//  Copyright © 2014-2015. Some rights reserved.
//

import Foundation

// MARK: Directory Enumeration

extension NSFileManager {
    
    public func directory(URL url: NSURL, fetchResources: [URLResourceType] = [], options mask: NSDirectoryEnumerationOptions = [], errorHandler handler: ((NSURL, NSError) -> Bool)? = nil) -> AnySequence<NSURL> {
        let keyStrings = fetchResources.map { $0.key }
        if let enumerator = enumeratorAtURL(url, includingPropertiesForKeys: keyStrings, options: mask, errorHandler: handler) {
            return AnySequence(enumerator.lazy.map(unsafeDowncast))
        } else {
            return AnySequence(EmptyGenerator())
        }
    }
    
}

