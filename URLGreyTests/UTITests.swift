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
        XCTAssert(type.dynamic)
    }
    
    func testAllIdentifiers() {
        let list = UTI.allIdentifiersForTag(.FilenameExtension("plist"))
        let first = list.first!
        let exts = first.pathExtensions
        print(exts)
    }

}
