//
//  URLError.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 3/26/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

public enum URLGreyError: Int, ErrorRepresentable {
    case InvalidResourceValue = -1000 // we couldn't coerce the value for key to the correct type
    
    public static var domain: String {
        return "me.waldowski.URLGrey.error"
    }
}
