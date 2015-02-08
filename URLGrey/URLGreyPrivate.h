//
//  URLGreyPrivate.h
//  URLGrey
//
//  Created by Zachary Waldowski on 2/7/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

@import Dispatch;
@import Foundation;

extern dispatch_data_t URLGreyCreateDispatchData(NSData *data);

#if OS_OBJECT_USE_OBJC

/// preferring this to unsafeBitcast
NS_INLINE NSData *URLGreyBridgeDispatchData(dispatch_data_t data) {
    return (NSData *)data;
}

#endif
