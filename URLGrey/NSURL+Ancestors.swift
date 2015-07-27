//
//  NSURL+Parents.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 3/30/15.
//  Copyright © 2014-2015. Some rights reserved.
//

import Foundation
import Lustre

// MARK: Result Types

public enum URLAncestorResult {
    case Failure(ErrorType)
    case Next(NSURL)
    case Root(NSURL)
}

extension URLAncestorResult: EitherType {
    
    public typealias Value = (URL: NSURL, isVolumeRoot: Bool)
    
    public init(left: ErrorType) {
        self = .Failure(left)
    }
    
    public init(right: Value) {
        if right.isVolumeRoot {
            self = .Root(right.URL)
        } else {
            self = .Next(right.URL)
        }
    }
    
    public func analysis<Result>(@noescape ifLeft ifLeft: ErrorType -> Result, @noescape ifRight: (URL: NSURL, isVolumeRoot: Bool) -> Result) -> Result {
        switch self {
        case .Failure(let error): return ifLeft(error)
        case .Next(let URL): return ifRight(URL: URL, isVolumeRoot: false)
        case .Root(let URL): return ifRight(URL: URL, isVolumeRoot: true)
        }
    }
    
}

// MARK: Generator

private struct URLAncestorsGenerator: GeneratorType {
    
    var nextURL: NSURL?
    
    init(URL: NSURL) {
        self.nextURL = URL
    }
    
    private mutating func next() -> URLAncestorResult? {
        guard let current = nextURL else { return nil }
        do {
            if try current.valueForResource(URLResource.IsVolume) {
                nextURL = nil
                return .Root(current)
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

// MARK: Ancestors extension

extension NSURL {
    
    public var ancestors: AnySequence<URLAncestorResult> {
        return AnySequence {
            URLAncestorsGenerator(URL: self)
        }
    }
    
}
