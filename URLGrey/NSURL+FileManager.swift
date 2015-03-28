//
//  NSURL+FileManager.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 3/27/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import Foundation
import Lustre

private extension NSFileManager {
    
    static let storage = ThreadLocalStorage<NSFileManager>()
    static var currentManager: NSFileManager {
        if NSThread.isMainThread() {
            return NSFileManager.defaultManager()
        }
        return storage.getValue(NSFileManager())
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
        return value(forResource: Resource.IsDirectory).value ?? false
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
    
    // TODO: backport and wrap
    // func getRelationship(outRelationship: UnsafeMutablePointer<NSURLRelationship>, ofDirectoryAtURL directoryURL: NSURL, toItemAtURL otherURL: NSURL, error: NSErrorPointer) -> Bool
    // func getRelationship(outRelationship: UnsafeMutablePointer<NSURLRelationship>, ofDirectory directory: NSSearchPathDirectory, inDomain domainMask: NSSearchPathDomainMask, toItemAtURL url: NSURL, error: NSErrorPointer) -> Bool
    
    // MARK: File management
    
    private func makeDirectory(#createIntermediates: Bool)(error: NSErrorPointer) -> Bool {
        return NSFileManager.currentManager.createDirectoryAtURL(self, withIntermediateDirectories: createIntermediates, attributes: nil, error: error)
    }
    
    private func copy(toURL url: NSURL)(error: NSErrorPointer) -> Bool {
        return NSFileManager.currentManager.copyItemAtURL(self, toURL: url, error: error)
    }
    
    private func move(toURL url: NSURL)(error: NSErrorPointer) -> Bool {
        return NSFileManager.currentManager.moveItemAtURL(self, toURL: url, error: error)
    }
    
    private func link(toURL url: NSURL)(error: NSErrorPointer) -> Bool {
        return NSFileManager.currentManager.linkItemAtURL(self, toURL: url, error: error)
    }
    
    private func remove(error: NSErrorPointer) -> Bool {
        return NSFileManager.currentManager.removeItemAtURL(self, error: error)
    }
    
    func makeDirectory(createIntermediates: Bool = true) -> VoidResult {
        return try(makeDirectory(createIntermediates: createIntermediates))
    }
    
    func copy(toURL url: NSURL) -> VoidResult {
        return try(copy(toURL: url))
    }
    
    func move(toURL url: NSURL) -> VoidResult {
        return try(move(toURL: url))
    }
    
    func replace(URL url: NSURL, backupName: String? = nil, options: NSFileManagerItemReplacementOptions = nil) -> ObjectResult<NSURL> {
        var newURL: NSURL?
        var error: NSError?
        if NSFileManager.currentManager.replaceItemAtURL(url, withItemAtURL: self, backupItemName: backupName, options: options, resultingItemURL: &newURL, error: &error) {
            return success(newURL!)
        } else {
            return failure(error!)
        }
    }
    
    func link(toURL url: NSURL) -> VoidResult {
        return try(link(toURL: url))
    }
    
    func remove() -> VoidResult {
        return try(remove)
    }
    
    func trash() -> ObjectResult<NSURL> {
        var newURL: NSURL?
        var error: NSError?
        if NSFileManager.currentManager.trashItemAtURL(self, resultingItemURL: &newURL, error: &error) {
            return success(newURL!)
        } else {
            return failure(error!)
        }
    }
    
    // MARK: Directory enumeration
    
    public func contents(fetchedResources: [_ResourceReadable]? = nil, options mask: NSDirectoryEnumerationOptions = nil, errorHandler handler: ((NSURL, NSError) -> Bool)? = nil) -> SequenceOf<NSURL> {
        return NSFileManager.currentManager.directory(URL: self, fetchResources: fetchedResources, options: mask, errorHandler: handler)
    }

}
