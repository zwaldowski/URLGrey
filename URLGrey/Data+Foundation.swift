//
//  Data+Foundation.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 2/7/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import Foundation
import URLGreyPrivate

extension Data {
    
    public init(data: NSData) {
        self.init(URLGreyCreateDispatchData(data))
    }
    
    public var objectValue: NSData {
        return URLGreyBridgeDispatchData(data)
    }
    
}
