//
//  NSURL+FileManager.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 3/27/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import Foundation
import Lustre

public extension NSFileManager {

    private static let storage = ThreadLocalStorage { NSFileManager.defaultManager() }
    
    static var currentManager: NSFileManager {
        return storage.getValue(create: NSFileManager())
    }
    
}

public extension NSURL {
    
    var isAbsolute: Bool {
        return absoluteURL === self
    }
    
    var isRelative: Bool {
        return !isAbsolute
    }
    
    var isDirectory: Bool {
        return value(forResource: .IsDirectory).value ?? false
    }
    
    func withCurrentDirectory<Result>(body: NSFileManager -> Result) -> Result? {
        if let path = path {
            let fm = NSFileManager.currentManager
            let oldPath = fm.currentDirectoryPath
            fm.changeCurrentDirectoryPath(path)
            let ret = body(fm)
            fm.changeCurrentDirectoryPath(oldPath)
            return ret
        }
        return nil
    }
    
    // MARK: Relationships
    
    func relationship(with item: NSURL) -> AnyResult<NSURLRelationship> {
        return NSFileManager.currentManager.relationship(directory: self, toItem: item)
    }

    // MARK: File management

    func makeDirectory(createIntermediates: Bool = true) -> VoidResult {
        return try {
            NSFileManager.currentManager.createDirectoryAtURL(self, withIntermediateDirectories: createIntermediates, attributes: nil, error: $0)
        }
    }
    
    func copy(toURL url: NSURL) -> VoidResult {
        return try {
            NSFileManager.currentManager.copyItemAtURL(self, toURL: url, error: $0)
        }
    }
    
    func move(toURL url: NSURL) -> VoidResult {
        return try {
            NSFileManager.currentManager.moveItemAtURL(self, toURL: url, error: $0)
        }
    }
    
    func replace(URL url: NSURL, backupName: String? = nil, options: NSFileManagerItemReplacementOptions = nil) -> ObjectResult<NSURL> {
        return try {
            NSFileManager.currentManager.replaceItemAtURL(url, withItemAtURL: self, backupItemName: backupName, options: options, resultingItemURL: $0, error: $1)
        }
    }
    
    func link(toURL url: NSURL) -> VoidResult {
        return try {
            NSFileManager.currentManager.linkItemAtURL(self, toURL: url, error: $0)
        }
    }
    
    func remove() -> VoidResult {
        return try {
            NSFileManager.currentManager.removeItemAtURL(self, error: $0)
        }
    }
    
    #if os(OSX)
    
    func trash() -> ObjectResult<NSURL> {
        return try {
            NSFileManager.currentManager.trashItemAtURL(self, resultingItemURL: $0, error: $1)
        }
    }
    
    #endif
    
    // MARK: Directory enumeration
    
    public func contents(fetchedResources: [ResourceType]? = nil, options mask: NSDirectoryEnumerationOptions = nil, errorHandler handler: ((NSURL, NSError) -> Bool)? = nil) -> SequenceOf<NSURL> {
        return NSFileManager.currentManager.directory(URL: self, fetchResources: fetchedResources, options: mask, errorHandler: handler)
    }

}
