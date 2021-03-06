//
//  NSFileManager+Relationships.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 3/29/15.
//  Copyright © 2014-2015. Some rights reserved.
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
                guard try directoryURL.valueForResource(URLResource.IsDirectory) else { return .Other }

                let URLs = [ directoryURL, itemURL ]
                let fileIDs = try URLs.map { try $0.valueForResource(URLResource.FileIdentifier) }
                guard !fileIDs[0].isEqual(fileIDs[1]) else { return .Same }
                
                let volIDs = try URLs.map { try $0.valueForResource(URLResource.VolumeIdentifier) }
                guard volIDs[0].isEqual(volIDs[1]) else { return .Other }
                
                let directoryID = fileIDs[0]
                parentsLoop: for parentResult in itemURL.ancestors {
                    switch parentResult {
                    case .Next(let parent):
                        let parentID = try parent.valueForResource(URLResource.FileIdentifier)
                        guard !parentID.isEqual(directoryID) else { return .Contains }
                    case .VolumeRoot:
                        break parentsLoop
                    case .Failure(let error):
                        throw error
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
