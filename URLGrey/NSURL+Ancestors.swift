//
//  NSURL+Parents.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 3/30/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import Foundation
import Lustre

// MARK: Result Types

public enum URLAncestorResult: ResultType {
    case Success(NSURL)
    case VolumeRoot(NSURL)
    case Failure(NSError)
    
    typealias Value = NSURL
    
    public init(failure error: NSError) {
        self = .Failure(error)
    }
    
    public var isSuccess: Bool {
        switch self {
        case .Success, .VolumeRoot: return true
        case .Failure: return false
        }
    }
    
    public var value: NSURL! {
        switch self {
        case .Success(let URL):    return .Some(URL)
        case .VolumeRoot(let URL): return .Some(URL)
        case .Failure(let error):  return .None
        }
    }
    
    public var error: NSError? {
        switch self {
        case .Success, .VolumeRoot: return nil
        case .Failure(let error):   return error
        }
    }
    
    public func flatMap<R: ResultType>(@noescape transform: NSURL -> R) -> R {
        switch self {
        case .Success(let URL):    return transform(URL)
        case .VolumeRoot(let URL): return transform(URL)
        case .Failure(let error):  return failure(error)
        }
    }
    
}

public struct URLAncestorsGenerator: GeneratorType {
    
    private var currentURL: NSURL?
    
    private init(URL: NSURL) {
        self.currentURL = URL
    }
    
    public mutating func next() -> URLAncestorResult? {
        if let current = currentURL {
            currentURL = nil
            
            let currentIsParent = current.value(forResource: .IsVolume)
            switch currentIsParent {
            case .Success(let value as Bool) where value == true:
                return .VolumeRoot(current)
            case .Failure(let error):
                return .Failure(error)
            default: break
            }
            
            return current.value(forResource: .ParentDirectoryURL) >>== { url -> URLAncestorResult in
                self.currentURL = url
                return .Success(current)
            }
        }
        return nil
    }
    
}

public struct URLAncestorsSequence: SequenceType {
    
    let URL: NSURL
    
    private init(URL: NSURL) {
        self.URL = URL
    }
    
    public func generate() -> URLAncestorsGenerator {
        return URLAncestorsGenerator(URL: URL)
    }
    
}

// MARK: URL navigation

public extension NSURL {
    
    public var ancestors: URLAncestorsSequence {
        return URLAncestorsSequence(URL: self)
    }
    
}
