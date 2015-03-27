//
//  IOError.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 1/10/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import Lustre

public enum IOError: ErrorRepresentable {
    
    case Unknown
    case Write
    case Read
    case Closed
    case UserCancelled
    
    public static var domain: String {
        return "me.waldowski.URLGrey.io.error"
    }
    
    public var code: Int {
        switch self {
        case .Unknown: return 0
        case .Write: return -1
        case .Read: return -2
        case .Closed: return -3
        case .UserCancelled: return -4
        }
    }
    
    public var description: String {
        return URLGrey.localizedString("The I/O operation failed", comment: "I/O error description")
    }
    
    public var failureReason: String {
        switch self {
        case .Unknown: return URLGrey.localizedString("An unknown error occured", comment: "I/O error reason")
        case .Write: return URLGrey.localizedString("A write error occured", comment: "I/O error reason")
        case .Read: return URLGrey.localizedString("A read error occured", comment: "I/O error reason")
        case .Closed: return URLGrey.localizedString("An attempt was made to perform I/O on a closed stream", comment: "I/O error reason")
        case .UserCancelled: return URLGrey.localizedString("Cancelled by user", comment: "I/O error reason")
        }
    }
    
}
