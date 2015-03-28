//
//  URLGreyPrivate.h
//  URLGrey
//
//  Created by Zachary Waldowski on 2/7/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

@import Foundation;
@import Darwin;

extern dispatch_data_t URLGreyCreateDispatchData(NSData *data);

#if OS_OBJECT_USE_OBJC

/// preferring this to unsafeBitcast
NS_INLINE NSData *URLGreyBridgeDispatchData(dispatch_data_t data) {
    return (NSData *)data;
}

#endif

extern pthread_key_t URLGreyCreateKeyForObject(void);
