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
    
    private var currentURL: NSURL?
    
    private init(URL: NSURL) {
        self.currentURL = URL
    }
    
    public mutating func next() -> URLAncestorResult? {
        if let current = currentURL {
            currentURL = nil
            
            let currentIsParent = current.value(forResource: .IsVolume)
            switch currentIsParent {
            case .Success(let value) where value == true:
                return .VolumeRoot(current)
            case .Failure(let error):
                return .Failure(error)
            default: break
            }
            
            switch current.value(forResource: .ParentDirectoryURL) {
            case .Success(let url):
                self.currentURL = url
                return .Next(current)
            case .Failure(let error):
                return .Failure(error)
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
