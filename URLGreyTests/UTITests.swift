//
//  UTITests.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 12/10/14.
//  Copyright (c) 2014 Zachary Waldowski. All rights reserved.
//

import URLGrey
import XCTest

class UTITests: XCTestCase {
    
    func testPreferredTagInitShouldntFail() {
        let type = UTI(preferredTag: .FilenameExtension("illogicallylongfilenameextension"), conformingTo: .Plain)
        XCTAssert(type != nil)
        XCTAssertTrue(type.dynamic)
    }

}
