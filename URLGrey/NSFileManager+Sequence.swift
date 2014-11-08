//
//  NSFileManager+Sequence.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 10/23/14.
//  Copyright (c) 2014 Zachary Waldowski. All rights reserved.
//

import Foundation

extension NSDirectoryEnumerator: SequenceType {
    
    public func generate() -> GeneratorOf<NSURL> {
        let generator = NSFastGenerator(self)
        return GeneratorOf {
            if let object: AnyObject = generator.next() {
                let ret: NSURL = unsafeDowncast(object)
                return ret
            }
            return nil
        }
    }
    
}

extension NSFileManager {
    
    public func directory(URL url: NSURL, propertiesForKeys keys: [String]? = nil, options mask: NSDirectoryEnumerationOptions = nil, errorHandler handler: ((NSURL, NSError) -> Bool)? = nil) -> SequenceOf<NSURL> {
        if let enumerator = enumeratorAtURL(url, includingPropertiesForKeys: keys, options: mask, errorHandler: handler.map {
            block in return { block($0, $1) }
        }) {
            return SequenceOf(enumerator)
        } else {
            return SequenceOf(GeneratorOf<NSURL> {
                return nil
            })
        }
    }
    
}

