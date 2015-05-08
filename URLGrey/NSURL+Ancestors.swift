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
    case Next(NSURL)
    case VolumeRoot(NSURL)
    case Failure(NSError)
    
    public typealias Value = (URL: NSURL, isVolumeRoot: Bool)
    
    public init(_ value: Value) {
        if value.isVolumeRoot {
            self = .VolumeRoot(value.URL)
        } else {
            self = .Next(value.URL)
        }
    }
    
    public init(failure error: NSError) {
        self = .Failure(error)
    }
    
    public func analysis<R>(@noescape #ifSuccess: Value -> R, @noescape ifFailure: NSError -> R) -> R {
        switch self {
        case .Next(let URL): return ifSuccess((URL, false))
        case .VolumeRoot(let URL): return ifSuccess((URL, true))
        case .Failure(let error): return ifFailure(error)
        }
    }
    
    public var value: Value? {
        return unbox(self)
    }
    
    public var error: NSError? {
        return errorOf(self)
    }
    
    /// Return the Result of mapping `transform` over `self`.
    public func flatMap<Result: ResultType>(@noescape transform: Value -> Result) -> Result {
        return Lustre.flatMap(self, transform)
    }
    
    /// Returns a new Result by mapping success cases using `transform`, or
    /// re-wrapping the error.
    public func map<Result: ResultType>(@noescape transform: Value -> Result.Value) -> Result {
        return Lustre.map(self, transform)
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
                return .Next(current)
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
