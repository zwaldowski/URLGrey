//
//  NSFileManager+Sequence.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 10/23/14.
//  Copyright (c) 2014 Zachary Waldowski. All rights reserved.
//

import Foundation

extension NSFileManager {
    
    public func directory(URL url: NSURL, fetchResources: [ResourceType]? = nil, options mask: NSDirectoryEnumerationOptions = nil, errorHandler handler: ((NSURL, NSError) -> Bool)? = nil) -> SequenceOf<NSURL> {
        let keyStrings = fetchResources?.map { $0.key as NSString }
        let unsafeHandler = handler.map { block -> (NSURL!, NSError!) -> Bool in
            { block($0, $1) }
        }
        
        if let enumerator = enumeratorAtURL(url, includingPropertiesForKeys: keyStrings, options: mask, errorHandler: unsafeHandler) {
            return SequenceOf(lazy(enumerator).map(unsafeDowncast))
        } else {
            return SequenceOf(EmptyGenerator())
        }
    }
    
}

