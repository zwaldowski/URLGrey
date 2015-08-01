//
//  RelationshipTests.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 3/30/15.
//  Copyright © 2014-2015. Some rights reserved.
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
        try! baseURL.makeDirectory()
        
        dirURL = baseURL + .Directory("folder")
        try! dirURL.makeDirectory()
        
        dirURL2 = baseURL + .Directory("otherFolder")
        try! dirURL2.makeDirectory()
        
        fileURL = dirURL + .File("file", .Plain)
        "This is a test".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)?.writeToURL(fileURL, atomically: false)
        
        fileURL2 = dirURL2 + .File("file", .PlainUTF16)
        "Ce ne est pas un test.".dataUsingEncoding(NSUTF16StringEncoding, allowLossyConversion: false)?.writeToURL(fileURL2, atomically: false)
        
        badURL = baseURL + .Filename("fake")
    }
    
    override func tearDown() {
        try! baseURL.remove()
        
        super.tearDown()
    }

    func testRelationships() {
        XCTAssert(try! fm.relationship(directory: baseURL, toItem: fileURL) == .Contains)
        XCTAssert(try! fm.relationship(directory: dirURL, toItem: fileURL)  == .Contains)
        XCTAssert(try! fm.relationship(directory: baseURL, toItem: baseURL) == .Same)
        XCTAssert(try! fm.relationship(directory: dirURL, toItem: fileURL2) == .Other)
        XCTAssert(try! fm.relationship(directory: fileURL, toItem: baseURL) == .Other)
        XCTAssert(try! fm.relationship(directory: fileURL, toItem: fileURL) == .Other)
    }
    
    func testRelationshipVolume() {
        let volume = try! fileURL.valueForResource(URLResource.VolumeURL)
        XCTAssert(try! fm.relationship(directory: volume, toItem: fileURL) == .Contains)
    }
    
    // it's always sad when a relationship fails
    func testRelationshipFailures() {
        do {
            let _ = try fm.relationship(directory: baseURL, toItem: badURL)
            XCTFail()
            let _ = try fm.relationship(directory: badURL, toItem: fileURL)
            XCTFail()
        } catch {}
    }
    
    func testSearchPathRelationships() {
        let appSupport = try! fm.URLForDirectory(.ApplicationSupportDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        
        XCTAssert(try! fm.relationship(directory: .LibraryDirectory, inDomain: .UserDomainMask, toItem: appSupport) == .Contains)
        XCTAssert(try! fm.relationship(directory: .CachesDirectory, inDomain: .UserDomainMask, toItem: appSupport) == .Other)
    }
    
    func testSearchPathRelationshipFailure() {
        do {
            let _ = try fm.relationship(directory: .LibraryDirectory, inDomain: .UserDomainMask, toItem: badURL)
            XCTFail()
        } catch {}
    }

}
