//
//  URLGrey.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 12/10/14.
//  Copyright (c) 2014 Zachary Waldowski. All rights reserved.
//

import Foundation

public protocol ErrorRepresentable: RawRepresentable {
    class var domain: String { get }
}

public func error<T: ErrorRepresentable where T.RawValue == Int>(#code: T, description : String? = nil) -> NSError {
    var userInfo = [NSObject: AnyObject]()
    if let description = description {
        userInfo[NSLocalizedDescriptionKey] = description
    }
    return NSError(domain: T.domain, code: code.rawValue, userInfo: nil)
}

public enum URLGreyError: Int, ErrorRepresentable {
    case InvalidResourceValue = -1000 // we couldn't coerce the value for key to the correct type
    
    public static var domain: String {
        return "me.waldowski.URLGrey.error"
    }
}
