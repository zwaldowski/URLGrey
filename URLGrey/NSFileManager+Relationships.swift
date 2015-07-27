//
//  NSFileManager+Relationships.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 3/29/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import Foundation

/// MARK: Relationship Calculating

public enum URLRelationship: Int {
    case Contains
    case Same
    case Other
}

extension NSFileManager {
    
    public func relationship(directory directoryURL: NSURL, toItem itemURL: NSURL) throws -> URLRelationship {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                let isDirectory = try directoryURL.valueForResource(URLResource.IsDirectory)
                guard isDirectory else { return .Other }
                
                let fileIDs = try NSURL.valuesForResource(URLResource.FileIdentifier, URLs: directoryURL, itemURL)
                guard !fileIDs[0].isEqual(fileIDs[1]) else { return .Same }
                
                let volIDs = try NSURL.valuesForResource(URLResource.VolumeIdentifier, URLs: directoryURL, itemURL)
                guard volIDs[0].isEqual(volIDs[1]) else { return .Other }
                
                let directoryID = fileIDs[0]
                for parentResult in itemURL.ancestors {
                    let (parent, _) = try parentResult.evaluate()
                    let parentID = try parent.valueForResource(URLResource.FileIdentifier)
                    if parentID.isEqual(directoryID) {
                        return .Contains
                    }
                }
                
                return .Other
            }
        #endif
        
        var rel = NSURLRelationship.Other
        try getRelationship(&rel, ofDirectoryAtURL: directoryURL, toItemAtURL: itemURL)
        return URLRelationship(rawValue: rel.rawValue)!
    }
    
    public func relationship(directory directoryType: NSSearchPathDirectory, inDomain domain: NSSearchPathDomainMask = [ .UserDomainMask ], toItem itemURL: NSURL) throws -> URLRelationship {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                let relatedURL = domain.isEmpty ? Optional.Some(itemURL) : nil
                let directoryURL = try URLForDirectory(directoryType, inDomain: domain, appropriateForURL: relatedURL, create: false)
                return try relationship(directory: directoryURL, toItem: itemURL)
            }
        #endif
        
        var rel = NSURLRelationship.Other
        try getRelationship(&rel, ofDirectory: directoryType, inDomain: domain, toItemAtURL: itemURL)
        return URLRelationship(rawValue: rel.rawValue)!
    }
    
}
