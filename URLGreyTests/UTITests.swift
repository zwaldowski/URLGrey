//
//  UTITests.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 12/10/14.
//  Copyright (c) 2014 Zachary Waldowski. All rights reserved.
//

import URLGrey
import XCTest

#if os(iOS)
    import UIKit
#endif

class UTITests: XCTestCase {
    
    func testPreferredTagInitShouldntFail() {
        let type = UTI(preferredTag: .FilenameExtension("illogicallylongfilenameextension"), conformingTo: UTI.Text.Plain)
        XCTAssert(type != nil)
        XCTAssertTrue(type.dynamic)
    }

}
