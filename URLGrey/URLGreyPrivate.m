//
//  URLGreyPrivate.m
//  URLGrey
//
//  Created by Zachary Waldowski on 2/7/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

#import "URLGreyPrivate.h"

dispatch_data_t _URLGreyCreateDispatchData(NSData *data, BOOL copy) {
    __block dispatch_data_t ret = nil;
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        dispatch_data_t chunk = nil;
        if (copy) {
            chunk = dispatch_data_create(bytes, byteRange.length, nil, DISPATCH_DATA_DESTRUCTOR_DEFAULT);
        } else {
            CFDataRef innerData = CFBridgingRetain(data);
            chunk = dispatch_data_create(bytes, byteRange.length, nil, ^{
                CFRelease(innerData);
            });
        }
        
        if (ret == nil) {
            ret = chunk;
        } else {
            ret = dispatch_data_create_concat(ret, chunk);
        }
    }];
    
    return ret ?: dispatch_data_empty;
}

dispatch_data_t URLGreyCreateDispatchData(NSData *data) {
    NSData *bridgedDispatchData = (NSData *)dispatch_data_empty;
    if ([data isMemberOfClass:bridgedDispatchData.class]) {
        return (dispatch_data_t)data;
    } else if (!data.length) {
        return dispatch_data_empty;
    } else if ([data isKindOfClass:NSMutableData.class]) {
        // copy all mutables
        return _URLGreyCreateDispatchData(data, YES);
    }
    // if copy == [self retain], reuse the optimization
    NSData *copied = [data copy];
    return _URLGreyCreateDispatchData(copied, copied != data);
}
