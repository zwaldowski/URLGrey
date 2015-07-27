//
//  NSFileManager+Relationships.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 3/29/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import Foundation
import Lustre

// TODO: consider moving this to Lustre
private extension Result {
    
    func bimap<RR: EitherType where RR.LeftType == ErrorType>(@noescape transform: T -> RR?) -> RR? {
        switch self {
        case .Success(let value): return transform(value)
        case .Failure(let error): return .Some(RR(left: error))
        }
    }
    
}

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
        
        if let isDir = directoryURL.value(forResource: .IsDirectory).bimap({
            $0 ? nil : Result.Success(NSURLRelationship.Other)
        }) { return isDir }
        
        let fileIDs = NSURL.values(forResource: .FileIdentifier, URLs: directoryURL, itemURL)
        if let areSame = fileIDs.bimap({
            return $0[0].isEqual($0[1]) ? Result.Success(NSURLRelationship.Same) : nil
        }) { return areSame }
        
        if let sameVolume = NSURL.values(forResource: .VolumeIdentifier, URLs: directoryURL, itemURL).bimap({
            $0[0].isEqual($0[1]) ? nil : Result.Success(NSURLRelationship.Other)
        }) { return sameVolume }
        
        let directoryID = fileIDs.map { $0[0] }
        for parentResult in itemURL.ancestors {
            let parentID = parentResult.flatMap { $0.0.value(forResource: .FileIdentifier) }
            
            switch (parentResult, parentID) {
            case (.Failure(let error), _):
                return Result.Failure(error)
            case (_, .Failure(let error)):
                return Result.Failure(error)
            case (_, .Success(let parentID)) where parentID.isEqual(directoryID.value):
                return Result.Success(.Contains)
            default: break
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
