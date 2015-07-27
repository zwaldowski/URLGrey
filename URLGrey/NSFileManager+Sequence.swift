//
//  NSFileManager+Sequence.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 10/23/14.
//  Copyright (c) 2014 Zachary Waldowski. All rights reserved.
//

import Foundation

// MARK: Directory Enumeration

extension NSFileManager {
    
    public func directory(URL url: NSURL, fetchResources: [ResourceType]? = nil, options mask: NSDirectoryEnumerationOptions = [], errorHandler handler: ((NSURL, NSError) -> Bool)? = nil) -> AnySequence<NSURL> {
        let keyStrings = fetchResources?.map { $0.key }
        let unsafeHandler = handler.map { block -> (NSURL!, NSError!) -> Bool in
            { block($0, $1) }
        }
                
        if let enumerator = enumeratorAtURL(url, includingPropertiesForKeys: keyStrings, options: mask, errorHandler: unsafeHandler) {
            return AnySequence(lazy(enumerator).map(unsafeDowncast))
        } else {
            return AnySequence(EmptyGenerator())
        }
    }
    
}

