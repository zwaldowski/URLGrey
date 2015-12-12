//
//  NSURL+Parents.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 3/30/15.
//  Copyright © 2014-2015. Some rights reserved.
//

import Foundation

// MARK: Result Types

public enum URLAncestorResult {
    case Next(NSURL)
    case VolumeRoot(NSURL)
    case Failure(ErrorType)
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
            guard try !current.valueForResource(URLResource.IsVolume) else {
                nextURL = nil
                return .VolumeRoot(current)
            }

            nextURL = try current.valueForResource(URLResource.ParentDirectoryURL)
            return .Next(current)
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
