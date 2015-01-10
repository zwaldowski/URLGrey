//
//  URLError.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 3/26/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

public enum URLError: ErrorRepresentable {
    case ReadResource(String) // getting a resource failed
    case InvalidResourceRead(String) // we couldn't coerce the value for key to the correct type
    case WriteResource(String) // setting a resource failed
    case InvalidResourceWrite(String) // we couldn't coerce the value for writing to key to the correct type
    
    public static var domain: String {
        return "me.waldowski.URLGrey"
    }
    
    public var code: Int {
        switch self {
        case .ReadResource: return -1000
        case .InvalidResourceRead: return -1001
        case .WriteResource: return -1002
        case .InvalidResourceWrite: return -1003
        }
    }
    
    public var description: String {
        return URLGrey.localizedString("A URL activity failed", comment: "URL error description")
    }
    
    public var failureReason: String? {
        switch self {
        case .ReadResource(let key):
            return URLGrey.localizedString("Retrieving a value for \(key) failed", comment: "URL error reason")
        case .InvalidResourceRead(let key):
            return URLGrey.localizedString("Retrieving a value for \(key) succeeded but the value was invalid", comment: "URL error reason")
        case .WriteResource(let key):
            return URLGrey.localizedString("Committing a value for \(key) failed", comment: "URL error reason")
        case .InvalidResourceWrite(let key):
            return URLGrey.localizedString("The value for writing to \(key) was invalid", comment: "URL error reason")
        }
    }
        
}
