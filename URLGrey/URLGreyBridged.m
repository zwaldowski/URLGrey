//
//  URLGreyBridged.m
//  URLGrey
//
//  Created by Zachary Waldowski on 2/7/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

@import Foundation;
@import Darwin;

static void cleanupObject(void *objectAsPtr) {
    if (objectAsPtr == NULL) { return; }
    CFBridgingRelease(objectAsPtr);
}

__attribute__((used, visibility("hidden"))) pthread_key_t _URLGreyCreateKeyForObject(void) {
    pthread_key_t key;
    if (pthread_key_create(&key, cleanupObject) != 0) {
        assert(false);
    }
    return key;
}
