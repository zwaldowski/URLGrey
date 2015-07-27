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
    
    func withCurrentDirectory<Result>(@noescape body: NSFileManager -> Result) -> Result? {
        guard let path = path else { return nil }
        let fm = NSFileManager.currentManager
        let oldPath = fm.currentDirectoryPath
        fm.changeCurrentDirectoryPath(path)
        let ret = body(fm)
        fm.changeCurrentDirectoryPath(oldPath)
        return ret
    }
    
    // MARK: Relationships
    
    // TODO: fix availability with backport
    @available(OSX 10.10, *)
    func relationship(with item: NSURL) -> Result<NSURLRelationship> {
        return NSFileManager.currentManager.relationship(directory: self, toItem: item)
    }

    // MARK: File management

    func makeDirectory(createIntermediates: Bool = true) -> Result<Void> {
        return Result {
            try NSFileManager.currentManager.createDirectoryAtURL(self, withIntermediateDirectories: createIntermediates, attributes: nil)
        }
    }
    
    func copy(toURL url: NSURL) -> Result<Void> {
        return Result {
            try NSFileManager.currentManager.copyItemAtURL(self, toURL: url)
        }
    }
    
    func move(toURL url: NSURL) -> Result<Void> {
        return Result {
            try NSFileManager.currentManager.moveItemAtURL(self, toURL: url)
        }
    }
    
    func replace(URL url: NSURL, backupName: String? = nil, options: NSFileManagerItemReplacementOptions = []) -> Result<NSURL> {
        return Result {
            var resultingURL: NSURL?
            try NSFileManager.currentManager.replaceItemAtURL(url, withItemAtURL: self, backupItemName: backupName, options: options, resultingItemURL: &resultingURL)
            return resultingURL!
        }
    }
    
    func link(toURL url: NSURL) -> Result<Void> {
        return Result {
            try NSFileManager.currentManager.linkItemAtURL(self, toURL: url)
        }
    }
    
    func remove() -> Result<Void> {
        return Result {
            try NSFileManager.currentManager.removeItemAtURL(self)
        }
    }
    
    #if os(OSX)
    
    func trash() -> Result<NSURL> {
        return Result {
            var resultingURL: NSURL?
            try NSFileManager.currentManager.trashItemAtURL(self, resultingItemURL: &resultingURL)
            return resultingURL!
        }
    }
    
    #endif
    
    // MARK: Directory enumeration
    
    public func contents(fetchedResources: [ResourceType]? = nil, options mask: NSDirectoryEnumerationOptions = [], errorHandler handler: ((NSURL, NSError) -> Bool)? = nil) -> AnySequence<NSURL> {
        return NSFileManager.currentManager.directory(URL: self, fetchResources: fetchedResources, options: mask, errorHandler: handler)
    }

}
