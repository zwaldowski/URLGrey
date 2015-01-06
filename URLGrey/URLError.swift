//
//  URLError.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 3/26/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

public enum URLGreyError: ErrorRepresentable {
    case InvalidResourceValue(String) // we couldn't coerce the value for key to the correct type
    
    public static var domain: String {
        return "me.waldowski.URLGrey.error"
    }
    
    public var code: Int {
        switch self {
        case .InvalidResourceValue: return -1000
        }
    }
    
    public var localizedDescription: String? {
        switch self {
        case .InvalidResourceValue(let key):
            return "Retrieving a value for \(key) succeeded, but the value was invalid."
        }
    }
}
