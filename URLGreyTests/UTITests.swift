//
//  UTITests.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 12/10/14.
//  Copyright © 2014-2015. Some rights reserved.
//

import URLGrey
import XCTest

class UTITests: XCTestCase {
    
    func testPreferredTagInitShouldntFail() {
        let type = UTI(preferredTag: .FilenameExtension("illogicallylongfilenameextension"), conformingTo: .Plain)
        XCTAssert(type != nil)
        if #available(OSX 10.10, *) {
            XCTAssertTrue(type.dynamic)
        } else {
            XCTFail("Backport not implemented yet")
        }
    }

}
