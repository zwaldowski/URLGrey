//
//  ResultTests.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 2/7/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import XCTest
import URLGrey

#if os(OSX)
    import Cocoa
#elseif os(iOS)
    import UIKit
#endif

class ResultTests: XCTestCase {
    
    let err = NSError(domain: "", code: 11, userInfo: nil)
    let err2 = NSError(domain: "", code: 12, userInfo: nil)
    
    func testSuccessIsSuccess() {
        let s = success(42)
        XCTAssertTrue(s.isSuccess)
    }
    
    func testFailureIsNotSuccess() {
        let f: AnyResult<NSError> = failure()
        XCTAssertFalse(f.isSuccess)
    }
    
    func testSuccessReturnsValue() {
        let s: AnyResult<Int> = success(42)
        XCTAssertEqual(s.value!, 42)
    }
    
    func testSuccessReturnsNoError() {
        let s: AnyResult<Int> = success(42)
        XCTAssert(s.error == nil)
    }
    
    func testFailureReturnsError() {
        let f: AnyResult<Int> = failure(self.err)
        XCTAssertEqual(f.error!, self.err)
    }
    
    func testFailureReturnsNoValue() {
        let f: AnyResult<Int> = failure(self.err)
        XCTAssertNil(f.value)
    }
    
    func testMapSuccessUnaryOperator() {
        let x: AnyResult<Int> = success(42)
        let y = x.map(-)
        XCTAssertEqual(y.value!, -42)
    }
    
    func testMapFailureUnaryOperator() {
        let x: AnyResult<Int> = failure(self.err)
        let y = x.map(-)
        XCTAssertNil(y.value)
        XCTAssertEqual(y.error!, self.err)
    }
    
    func testMapSuccessNewType() {
        let x: AnyResult<String> = success("abcd")
        let y = x.map { countElements($0) }
        XCTAssertEqual(y.value!, 4)
    }
    
    func testMapFailureNewType() {
        let x: AnyResult<String> = failure(self.err)
        let y = x.map { countElements($0) }
        XCTAssertEqual(y.error!, self.err)
    }
    
    func doubleSuccess(x: Int) -> AnyResult<Int> {
        return success(x * 2)
    }
    
    func doubleFailure(x: Int) -> AnyResult<Int> {
        return failure(self.err)
    }
    
    func testFlatMapSuccessSuccess() {
        let x: AnyResult<Int> = success(42)
        let y = x.flatMap(doubleSuccess)
        XCTAssertEqual(y.value!, 84)
    }
    
    func testFlatMapSuccessFailure() {
        let x: AnyResult<Int> = success(42)
        let y = x.flatMap(doubleFailure)
        XCTAssertEqual(y.error!, self.err)
    }
    
    func testFlatMapFailureSuccess() {
        let x: AnyResult<Int> = failure(self.err2)
        let y = x.flatMap(doubleSuccess)
        XCTAssertEqual(y.error!, self.err2)
    }
    
    func testFlatMapFailureFailure() {
        let x: AnyResult<Int> = failure(self.err2)
        let y = x.flatMap(doubleFailure)
        XCTAssertEqual(y.error!, self.err2)
    }
    
    func testDescriptionSuccess() {
        let x: AnyResult<Int> = success(42)
        XCTAssertEqual(x.description, "Success: 42")
    }
    
    func testDescriptionFailure() {
        let x: AnyResult<String> = failure()
        XCTAssert(x.description.hasPrefix("Failure: Error Domain= Code=0 "))
    }
    
    func testCoalesceSuccess() {
        let r: AnyResult<Int> = success(42)
        let x = r ?? 43
        XCTAssertEqual(x, 42)
    }
    
    func testCoalesceFailure() {
        let x = failure() ?? 43
        XCTAssertEqual(x, 43)
    }
    
    private func makeTryFunction<T>(x: T, _ succeed: Bool = true)(error: NSErrorPointer) -> T {
        if !succeed {
            error.memory = NSError(domain: "domain", code: 1, userInfo: [:])
        }
        return x
    }
    
    func testTryTSuccess() {
        XCTAssertEqual(try(makeTryFunction(42 as Int?)) ?? 43, 42)
    }
    
    func testTryTFailure() {
        let result = try(makeTryFunction(nil as Int?, false))
        XCTAssertEqual(result ?? 43, 43)
        XCTAssert(result.description.hasPrefix("Failure: Error Domain=domain Code=1 "))
    }
    
    func testTryBoolSuccess() {
        XCTAssert(try(makeTryFunction(true)).isSuccess)
    }
    
    func testTryBoolFailure() {
        let result = try(makeTryFunction(false, false))
        XCTAssertFalse(result.isSuccess)
        XCTAssert(result.description.hasPrefix("Failure: Error Domain=domain Code=1 "))
    }
    
}
