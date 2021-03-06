//
//  IOChannelTests.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 1/10/15.
//  Copyright © 2014-2015. Some rights reserved.
//

import XCTest
@testable import URLGrey

class IOChannelTests: XCTestCase {
    
    func testRead() {
        
        var pattern: [UInt8] = [ 0xA, 0xB, 0xC, 0xD, 0xE, 0xF, 0x12 ]
        var buffer: [UInt8] = Array(count: 1024 * 10, repeatedValue: 0)
        memset_pattern8(&buffer, &pattern, buffer.count)
        
        let queue = dispatch_get_global_queue(0, 0)
        
        // Set up a socket pair for testing
        let (rfd, wfd) = { _ -> (Int32, Int32) in
            var pair = [Int32](count: 2, repeatedValue: 0)
            XCTAssertEqual(socketpair(PF_LOCAL, SOCK_STREAM, 0, &pair), 0, "Failed to create socket pair")
            return (pair[0], pair[1])
        }()
        
        // Initialize stream
        let src = IOChannel<UInt8>(fileDescriptor: rfd, closeWhenDone: true)
        
        // Spawn writer
        dispatch_async(queue) {
            let length = buffer.count
            var written = 0
            
            while written < length {
                var chunk = 0
                var res = 0
                
                let writeNext = { () -> Bool in
                    let ret = write(wfd, &buffer + written, min(length-written, 1024-chunk))
                    res = ret
                    return ret > 0
                }
                
                while 1024 - chunk > 0 && writeNext() {
                    written += res
                    chunk += res
                }
            }
            
            // Once writes are complete, close to trigger EOF for the reader
            close(wfd)
        }
        
        let expect = expectationWithDescription("Copy finish")
        var result = Data<UInt8>()
        
        // Set up reader
        src.readUntilEnd(queue: queue) {
            guard case let .Success(newData) = $0 else {
                XCTFail("Unexpected failure")
                return
            }

            result += newData

            if newData.isEmpty {
                XCTAssert(result.elementsEqual(buffer), "The data was corrupted during the copy")
                expect.fulfill()
            }
        }
        
        waitForExpectationsWithTimeout(20, handler: nil)
    }
    
}
