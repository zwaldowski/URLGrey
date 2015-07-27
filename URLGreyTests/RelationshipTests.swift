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
        
        let root = NSURL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        
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
        if #available(OSX 10.10, *) {
            XCTAssert(fm.relationship(directory: baseURL, toItem: fileURL) == Result.Success(.Contains))
            XCTAssert(fm.relationship(directory: dirURL, toItem: fileURL) == Result.Success(.Contains))
            XCTAssert(fm.relationship(directory: baseURL, toItem: baseURL) == Result.Success(.Same))
            XCTAssert(fm.relationship(directory: dirURL, toItem: fileURL2) == Result.Success(.Other))
            XCTAssert(fm.relationship(directory: fileURL, toItem: baseURL) == Result.Success(.Other))
            XCTAssert(fm.relationship(directory: fileURL, toItem: fileURL) == Result.Success(.Other))
        } else {
            XCTFail("Backport not implemented yet")
        }
    }
    
    func testRelationshipVolume() {
        let volume = fileURL.value(forResource: .VolumeURL)
        if #available(OSX 10.10, *) {
            XCTAssert(fm.relationship(directory: volume.value!, toItem: fileURL) == Result.Success(.Contains))
        } else {
            XCTFail("Backport not implemented yet")
        }
    }
    
    // it's always sad when a relationship fails
    func testRelationshipFailures() {
        if #available(OSX 10.10, *) {
            XCTAssert(fm.relationship(directory: baseURL, toItem: badURL).error != nil)
            XCTAssert(fm.relationship(directory: badURL, toItem: fileURL).error != nil)
        } else {
            XCTFail("Backport not implemented yet")
        }
    }
    
    func testSearchPathRelationships() {
        if #available(OSX 10.10, *) {
            let appSupport = try! fm.URLForDirectory(.ApplicationSupportDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
            XCTAssertNotNil(appSupport)
            
            XCTAssert(fm.relationship(directory: .LibraryDirectory, inDomain: .UserDomainMask, toItem: appSupport) == Result.Success(.Contains))
            XCTAssert(fm.relationship(directory: .CachesDirectory, inDomain: .UserDomainMask, toItem: appSupport) == Result.Success(.Other))
        } else {
            XCTFail("Backport not implemented yet")
        }
    }
    
    func testSearchPathRelationshipFailure() {
        if #available(OSX 10.10, *) {
            XCTAssert(fm.relationship(directory: .LibraryDirectory, inDomain: .UserDomainMask, toItem: badURL).error != nil)
        } else {
            XCTFail("Backport not implemented yet")
        }
    }

}
