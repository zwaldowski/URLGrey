//
//  Data+Foundation.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 2/7/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import Foundation

extension Data {
    
    private static func wrapToDispatchData(data: NSData, copy: Bool = true) -> dispatch_data_t {
        var ret: dispatch_data_t?
        
        data.enumerateByteRangesUsingBlock { (bytes, byteRange, _) in
            let chunk: dispatch_data_t
            if copy {
                chunk = dispatch_data_create(bytes, byteRange.length, nil, nil)
            } else {
                let innerData = Unmanaged.passRetained(data)
                chunk = dispatch_data_create(bytes, byteRange.length, nil) {
                    innerData.release()
                }
            }
            
            if let current = ret {
                ret = dispatch_data_create_concat(current, chunk)
            } else {
                ret = chunk
            }
        }
        
        return ret ?? dispatch_data_empty
    }
    
    public init(data: NSData) {
        let dispatchData: dispatch_data_t
        if let data = data as? dispatch_data_t {
            dispatchData = data
        } else if data.length == 0 {
            dispatchData = dispatch_data_empty
        } else if data is NSMutableData {
            dispatchData = Data.wrapToDispatchData(data)
        } else {
            let copied: NSData = unsafeDowncast(data.copy())
            dispatchData = Data.wrapToDispatchData(copied, copy: copied !== data)
        }
        self.init(dispatchData)
    }
    
    public var objectValue: NSData {
        precondition(OS_OBJECT_USE_OBJC != 0, "Not running with ObjC bridging - this is required")
        return unsafeBitCast(data, NSData.self)
    }
    
}
