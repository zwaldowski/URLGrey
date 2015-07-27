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

public enum URLAncestorResult: EitherType {
    case Next(NSURL)
    case VolumeRoot(NSURL)
    case Failure(ErrorType)
    
    public typealias Value = (URL: NSURL, isVolumeRoot: Bool)
    
    public init(left: ErrorType) {
        self = .Failure(left)
    }
    
    public init(right: Value) {
        if right.isVolumeRoot {
            self = .VolumeRoot(right.URL)
        } else {
            self = .Next(right.URL)
        }
    }
    
    public func analysis<Result>(@noescape ifLeft ifLeft: ErrorType -> Result, @noescape ifRight: (URL: NSURL, isVolumeRoot: Bool) -> Result) -> Result {
        switch self {
        case .Next(let URL): return ifRight(URL: URL, isVolumeRoot: false)
        case .VolumeRoot(let URL): return ifRight(URL: URL, isVolumeRoot: true)
        case .Failure(let error): return ifLeft(error)
        }
    }
    
}

public struct URLAncestorsGenerator: GeneratorType {
    
    private var nextURL: NSURL?
    
    private init(URL: NSURL) {
        self.nextURL = URL
    }
    
    public mutating func next() -> URLAncestorResult? {
        guard let current = nextURL else { return nil }
        do {
            if try current.valueForResource(URLResource.IsVolume) {
                nextURL = nil
                return .VolumeRoot(current)
            } else {
                nextURL = try current.valueForResource(URLResource.ParentDirectoryURL)
                return .Next(current)
            }
        } catch {
            nextURL = nil
            return .Failure(error)
        }
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
