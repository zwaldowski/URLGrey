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
private extension AnyResult {
    
    func bimap<RR: ResultType>(@noescape transform: T -> RR?) -> RR? {
        switch self {
        case .Success(let value as T): return transform(value)
        case .Success:                 return nil
        case .Failure(let error):      return .Some(failure(error))
        }
    }
    
}

/// MARK: Relationship Calculating

public extension NSFileManager {
    
    private static let hasNativeGetRelationship: Bool = {
        NSFileManager.instancesRespondToSelector("getRelationship:ofDirectoryAtURL:toItemAtURL:error:")
    }()
    
    func relationship(directory directoryURL: NSURL, toItem itemURL: NSURL) -> AnyResult<NSURLRelationship> {
        if NSFileManager.hasNativeGetRelationship {
            return try { getRelationship($0, ofDirectoryAtURL: directoryURL, toItemAtURL: itemURL, error: $1) }
        }
        
        if let isDir = directoryURL.value(forResource: .IsDirectory).bimap({
            $0 ? nil : success(NSURLRelationship.Other)
        }) { return isDir }
        
        let fileIDs = NSURL.values(forResource: .FileIdentifier, URLs: directoryURL, itemURL)
        if let areSame = fileIDs.bimap({
            return $0[0].isEqual($0[1]) ? success(NSURLRelationship.Same) : nil
        }) { return areSame }
        
        if let sameVolume = NSURL.values(forResource: .VolumeIdentifier, URLs: directoryURL, itemURL).bimap({
            $0[0].isEqual($0[1]) ? nil : success(NSURLRelationship.Other)
        }) { return sameVolume }
        
        let directoryID = fileIDs.map { $0[0] }
        for parentResult in itemURL.ancestors {
            let parentID = flatMap(parentResult) { $0.0.value(forResource: .FileIdentifier) }
            
            switch (parentResult, parentID) {
            case (.Failure(let error), _):
                return failure(error)
            case (_, .Failure(let error)):
                return failure(error)
            case (_, .Success(let parentID)) where parentID.isEqual(directoryID.value):
                return success(.Contains)
            default: break
            }
        }
        
        return success(.Other)
    }
    
    func relationship(directory directoryType: NSSearchPathDirectory, inDomain domain: NSSearchPathDomainMask = .UserDomainMask, toItem itemURL: NSURL) -> AnyResult<NSURLRelationship> {
        if NSFileManager.hasNativeGetRelationship {
            return try { getRelationship($0, ofDirectory: directoryType, inDomain: domain, toItemAtURL: itemURL, error: $1) }
        }
        
        return try { error in
            URLForDirectory(directoryType, inDomain: domain, appropriateForURL: domain == nil ? itemURL : nil, create: false, error: error)
        } >>== {
            relationship(directory: $0, toItem: itemURL)
        }
    }
    
}
