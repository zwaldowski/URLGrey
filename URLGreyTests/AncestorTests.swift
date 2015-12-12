//
//  AncestorTests.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 3/30/15.
//  Copyright © 2014-2015. Some rights reserved.
//

import XCTest
@testable import URLGrey

class AncestorTests: XCTestCase {
    
    private var fm: NSFileManager!

    override func setUp() {
        super.setUp()
        
        fm = NSFileManager()
    }
    
    override func tearDown() {
        fm = nil
        
        super.tearDown()
    }
    
    // file:///System/Library/CoreServices/SystemVersion.plist is a pretty
    // stable target on Darwin volumes, but not anywhere else. If Swift ever
    // runs on something else, someone let me know.
    func testURLParents() {
        let sysLib = try! fm.URLForDirectory(.LibraryDirectory, inDomain: .SystemDomainMask, appropriateForURL: nil, create: false)
        XCTAssertNotNil(sysLib)
        
        let sysVersion = sysLib + .Directory("CoreServices") + .File("SystemVersion", .PropertyList)
        
        var validParents = 0
        let expectedValidParents = 5
        var reachedRoot = false
        
        for i in sysVersion.ancestors {
            switch i {
            case .Next:
                ++validParents
            case .VolumeRoot:
                reachedRoot = true
                ++validParents
            case .Failure(let error):
                XCTFail("Unexpected error: \(error)")
            }
        }
        
        XCTAssert(reachedRoot)
        XCTAssertEqual(validParents, expectedValidParents)
    }

}
