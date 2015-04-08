//
//  RelationshipTests.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 3/30/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import XCTest
import URLGrey
import Lustre

#if os(OSX)
import Cocoa
#elseif os(iOS)
import UIKit
#endif

class RelationshipTests: XCTestCase {
    
    private var fm: NSFileManager { return NSFileManager.currentManager }

    var baseURL: NSURL!
    var dirURL: NSURL!
    var dirURL2: NSURL!
    var fileURL: NSURL!
    var fileURL2: NSURL!
    var badURL: NSURL!

    override func setUp() {
        super.setUp()
        
        let root = NSURL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)!
        
        baseURL = root + .Directory("\(NSStringFromClass(self.dynamicType))_\(NSUserName())_\(NSProcessInfo.processInfo().globallyUniqueString)")
        baseURL.remove()
        baseURL.makeDirectory()
        
        dirURL = baseURL + .Directory("folder")
        dirURL.makeDirectory()
        
        dirURL2 = baseURL + .Directory("otherFolder")
        dirURL2.makeDirectory()
        
        fileURL = dirURL + .File("file", .Plain)
        "This is a test".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)?.writeToURL(fileURL, atomically: false)
        
        fileURL2 = dirURL2 + .File("file", .PlainUTF16)
        "Ce ne est pas un test.".dataUsingEncoding(NSUTF16StringEncoding, allowLossyConversion: false)?.writeToURL(fileURL2, atomically: false)
        
        badURL = baseURL + .Filename("fake")
    }

    func testRelationships() {
        XCTAssert(fm.relationship(directory: baseURL, toItem: fileURL) == success(.Contains))
        XCTAssert(fm.relationship(directory: dirURL, toItem: fileURL) == success(.Contains))
        XCTAssert(fm.relationship(directory: baseURL, toItem: baseURL) == success(.Same))
        XCTAssert(fm.relationship(directory: dirURL, toItem: fileURL2) == success(.Other))
        XCTAssert(fm.relationship(directory: fileURL, toItem: baseURL) == success(.Other))
        XCTAssert(fm.relationship(directory: fileURL, toItem: fileURL) == success(.Other))
    }
    
    func testRelationshipVolume() {
        let volume = fileURL.value(forResource: .VolumeURL)
        XCTAssert(fm.relationship(directory: volume.value, toItem: fileURL) == success(.Contains))
    }
    
    // it's always sad when a relationship fails
    func testRelationshipFailures() {
        XCTAssertNotNil(fm.relationship(directory: baseURL, toItem: badURL).error)
        XCTAssertNotNil(fm.relationship(directory: badURL, toItem: fileURL).error)
    }
    
    func testSearchPathRelationships() {
        let appSupport = fm.URLForDirectory(.ApplicationSupportDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false, error: nil)!
        XCTAssertNotNil(appSupport)
        
        XCTAssert(fm.relationship(directory: .LibraryDirectory, inDomain: .UserDomainMask, toItem: appSupport) == success(.Contains))
        XCTAssert(fm.relationship(directory: .CachesDirectory, inDomain: .UserDomainMask, toItem: appSupport) == success(.Other))
    }
    
    func testSearchPathRelationshipFailure() {
        XCTAssertNotNil(fm.relationship(directory: .LibraryDirectory, inDomain: .UserDomainMask, toItem: badURL).error)
    }

}
