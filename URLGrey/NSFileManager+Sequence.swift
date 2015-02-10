//
//  NSFileManager+Sequence.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 10/23/14.
//  Copyright (c) 2014 Zachary Waldowski. All rights reserved.
//

import Foundation

extension NSFileManager {
    
    public func directory(URL url: NSURL, propertiesForKeys keys: [String]? = nil, options mask: NSDirectoryEnumerationOptions = nil, errorHandler handler: ((NSURL, NSError) -> Bool)? = nil) -> SequenceOf<NSURL> {
        if let enumerator = enumeratorAtURL(url, includingPropertiesForKeys: keys, options: mask, errorHandler: handler.map {
            block in { block($0, $1) }
        }) {
            var generator = enumerator.generate()
            return SequenceOf(GeneratorOf {
                generator.next().map {
                    unsafeDowncast($0)
                }
            })
        } else {
            return SequenceOf(EmptyGenerator())
        }
    }
    
}

