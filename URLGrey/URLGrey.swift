//
//  URLGrey.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 1/10/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import Foundation
import Lustre

@objc private final class _URLGreyClassForLookup {}

internal struct URLGrey {
    
    static var bundle: NSBundle {
        return NSBundle(forClass: _URLGreyClassForLookup.self)
    }
    
    static func localizedString(key: String, tableName: String? = nil, value: String = "", comment: String) -> String {
        return bundle.localizedStringForKey(key, value: tableName, table: nil)
    }
    
    static func localizedString(#format: String, tableName: String? = nil, value: String = "", comment: String, _ args: CVarArgType...) -> String {
        return String(format: localizedString(format, tableName: tableName, value: value, comment: comment), arguments: args)
    }
    
}
