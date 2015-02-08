//
//  URLGreyPrivate.h
//  URLGrey
//
//  Created by Zachary Waldowski on 2/7/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

@import Foundation;
@import Dispatch;

#ifndef __has_feature
#define __has_feature(x) 0
#endif

#if !__has_feature(objc_arc)
#error This file must be compiled using Objective-C ARC.
#endif

extern dispatch_data_t URLGreyCreateDispatchData(NSData *data);

#if OS_OBJECT_USE_OBJC

/// preferring this to unsafeBitcast
NS_INLINE NSData *URLGreyBridgeDispatchData(dispatch_data_t data) {
    return (NSData *)data;
}

#endif
