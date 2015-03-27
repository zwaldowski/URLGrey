//
//  URLError.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 3/26/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import Lustre

public enum URLError: ErrorRepresentable {
    case ResourceRead(String) // getting a resource failed
    case ResourceReadUnavailable // getting a resource succeeded, but it was empty
    case ResourceReadConversion // we couldn't coerce the value for key to the correct type
    case ResourceWriteConversion // we couldn't coerce the value for writing to key to the correct type
    case ResourceWrite(String) // setting a resource failed

    public static var domain: String {
        return "me.waldowski.URLGrey"
    }
    
    public var code: Int {
        switch self {
        case ResourceRead:            return -1000
        case ResourceReadUnavailable: return -1001
        case ResourceReadConversion:  return -1002
        case ResourceWriteConversion: return -1003
        case ResourceWrite:           return -1004
        }
    }
    
    public var description: String {
        return URLGrey.localizedString("A URL activity failed", comment: "URL error description")
    }
    
    public var failureReason: String {
        switch self {
        case .ResourceRead(let key):
            return URLGrey.localizedString("Retrieving a value for \(key) failed", comment: "URL error reason")
        case .ResourceReadUnavailable:
            return URLGrey.localizedString("No values for the given resource were available", comment: "URL error reason")
        case .ResourceReadConversion:
            return URLGrey.localizedString("Retrieving a value for succeeded but could not be converted to the native type", comment: "URL error reason")
        case .ResourceWriteConversion:
            return URLGrey.localizedString("The value for writing could not be converted to the native type", comment: "URL error reason")
        case .ResourceWrite(let key):
            return URLGrey.localizedString("Committing a value for \(key) failed", comment: "URL error reason")
        }
    }
    
}
