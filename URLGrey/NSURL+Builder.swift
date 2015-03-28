//
//  NSURL+Builder.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 3/27/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import Foundation

public enum PathComponent {
    case Extension(UTI)
    case File(String, UTI)
    case Filename(String)
    case Directory(String)
}

public func +(lhs: NSURL, rhs: PathComponent) -> NSURL {
    switch rhs {
    case .Extension(let uti):
        if let ext = uti.preferredPathExtension {
            return lhs.URLByAppendingPathExtension(ext)
        } else {
            return lhs
        }
    case .File(let name, let uti):
        let withName = lhs.URLByAppendingPathComponent(name, isDirectory: false)
        if let ext = uti.preferredPathExtension {
            return withName.URLByAppendingPathExtension(ext)
        } else {
            return withName
        }
    case .Filename(let name):
        return lhs.URLByAppendingPathComponent(name, isDirectory: false)
    case .Directory(let dir):
        return lhs.URLByAppendingPathComponent(dir, isDirectory: true)
    }
}

public func +(lhs: NSURL, rhs: String) -> NSURL {
    return lhs.URLByAppendingPathComponent(rhs)
}

public func +=(inout lhs: NSURL, rhs: PathComponent) {
    lhs = lhs + rhs
}

public func +=(inout lhs: NSURL, rhs: String) {
    lhs = lhs + rhs
    
}
