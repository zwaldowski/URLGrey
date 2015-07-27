//
//  NSURL+FileManager.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 3/27/15.
//  Copyright © 2014-2015. Some rights reserved.
//

import Foundation

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
        do {
            return try valueForResource(URLResource.IsDirectory)
        } catch {
            return false
        }
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
    
    func relationship(with item: NSURL) throws -> URLRelationship {
        return try NSFileManager.currentManager.relationship(directory: self, toItem: item)
    }

    // MARK: File management

    func makeDirectory(createIntermediates: Bool = true) throws {
        try NSFileManager.currentManager.createDirectoryAtURL(self, withIntermediateDirectories: createIntermediates, attributes: nil)
    }
    
    func copy(toURL url: NSURL) throws {
        try NSFileManager.currentManager.copyItemAtURL(self, toURL: url)
    }
    
    func move(toURL url: NSURL) throws {
        try NSFileManager.currentManager.moveItemAtURL(self, toURL: url)
    }
    
    func replace(URL url: NSURL, backupName: String? = nil, options: NSFileManagerItemReplacementOptions = []) throws -> NSURL {
        var resultingURL: NSURL?
        try NSFileManager.currentManager.replaceItemAtURL(url, withItemAtURL: self, backupItemName: backupName, options: options, resultingItemURL: &resultingURL)
        return unsafeUnwrap(resultingURL)
    }
    
    func link(toURL url: NSURL) throws {
        try NSFileManager.currentManager.linkItemAtURL(self, toURL: url)
    }
    
    func remove() throws {
        try NSFileManager.currentManager.removeItemAtURL(self)
    }
    
    #if os(OSX)
    
    func trash() throws -> NSURL {
        var resultingURL: NSURL?
        try NSFileManager.currentManager.trashItemAtURL(self, resultingItemURL: &resultingURL)
        return unsafeUnwrap(resultingURL)
    }
    
    #endif
    
    // MARK: Directory enumeration
    
    public func contents(fetchResources fetchResources: [URLResourceType] = [], options mask: NSDirectoryEnumerationOptions = [], errorHandler handler: ((NSURL, NSError) -> Bool)? = nil) -> AnySequence<NSURL> {
        return NSFileManager.currentManager.directory(URL: self, fetchResources: fetchResources, options: mask, errorHandler: handler)
    }

}
