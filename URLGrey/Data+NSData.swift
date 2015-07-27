//
//  Data+NSData.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 2/7/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import Foundation

private extension NSData {
    
    private func wrapToDispatchData(copy copy: Bool) -> dispatch_data_t {
        var ret: dispatch_data_t?
        enumerateByteRangesUsingBlock { (bytes, byteRange, _) in
            let chunk: dispatch_data_t
            if copy {
                chunk = dispatch_data_create(bytes, byteRange.length, nil, nil)
            } else {
                let innerData = Unmanaged.passRetained(self)
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
    
    @nonobjc var dispatchValue: dispatch_data_t {
        if length == 0 {
            return dispatch_data_empty
        } else if let dd = self as? dispatch_data_t {
            return dd
        } else if self is NSMutableData {
            return wrapToDispatchData(copy: true)
        } else {
            let copied: NSData = unsafeDowncast(copy())
            return copied.wrapToDispatchData(copy: copied !== self)
        }
    }
    
}

extension Data {
    
    public init(_ data: NSData) {
        self.init(data.dispatchValue)
    }
    
}
