//
//  NSFileManager+Relationships.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 3/29/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import Foundation
import Lustre

/// MARK: Relationship Calculating

public extension NSFileManager {
    
    private static let hasNativeGetRelationship: Bool = {
        NSFileManager.instancesRespondToSelector("getRelationship:ofDirectoryAtURL:toItemAtURL:error:")
    }()
    
    // TODO: fix this availability, just for NSURLRelationship
    @available(OSX 10.10, *)
    func relationship(directory directoryURL: NSURL, toItem itemURL: NSURL) -> Result<NSURLRelationship> {
        if NSFileManager.hasNativeGetRelationship {
            return Result {
                var relationship = NSURLRelationship.Other
                try getRelationship(&relationship, ofDirectoryAtURL: directoryURL, toItemAtURL: itemURL)
                return relationship
            }
        }
        
        let isDirectory: Bool
        do {
            isDirectory = try directoryURL.valueForResource(URLResource.IsDirectory)
        } catch {
            return Result.Failure(error)
        }
        
        guard isDirectory else { return Result.Success(NSURLRelationship.Other) }
        
        let fileIDs: [OpaqueType]
        do {
            fileIDs = try NSURL.valuesForResource(URLResource.FileIdentifier, URLs: directoryURL, itemURL)
        } catch {
            return Result.Failure(error)
        }
        
        guard !fileIDs[0].isEqual(fileIDs[1]) else { return Result.Success(NSURLRelationship.Same) }

        let volIDs: [OpaqueType]
        do {
            volIDs = try NSURL.valuesForResource(URLResource.VolumeIdentifier, URLs: directoryURL, itemURL)
        } catch {
            return Result.Failure(error)
        }

        guard volIDs[0].isEqual(volIDs[1]) else { return Result.Success(NSURLRelationship.Other) }
        
        let directoryID = fileIDs[0]
        for parentResult in itemURL.ancestors {
            do {
                let (parent, _) = try parentResult.evaluate()
                let parentID = try parent.valueForResource(URLResource.FileIdentifier)
                if parentID.isEqual(directoryID) {
                    return Result.Success(NSURLRelationship.Contains)
                }
            } catch {
                return Result.Failure(error)
            }
        }
        
        return Result.Success(.Other)
    }
    
    // TODO: fix this availability, just for NSURLRelationship
    @available(OSX 10.10, *)
    func relationship(directory directoryType: NSSearchPathDirectory, inDomain domain: NSSearchPathDomainMask = .UserDomainMask, toItem itemURL: NSURL) -> Result<NSURLRelationship> {
        if NSFileManager.hasNativeGetRelationship {
            return Result {
                var relationship = NSURLRelationship.Other
                try getRelationship(&relationship, ofDirectory: directoryType, inDomain: domain, toItemAtURL: itemURL)
                return relationship
            }
        }
        
        return Result<NSURL> {
            try URLForDirectory(directoryType, inDomain: domain, appropriateForURL: domain == [] ? itemURL : nil, create: false)
        }.flatMap {
            relationship(directory: $0, toItem: itemURL)
        }
    }
    
}
