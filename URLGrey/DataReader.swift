//
//  DataReader.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 1/10/15.
//  Copyright © 2014-2015. Some rights reserved.
//

import Dispatch

public enum DataReadResult<Element: UnsignedIntegerType> {
    case Success(Data<Element>)
    case Failure(ErrorType)
}

extension DataReadResult {

    public init() {
        self = .Success(Data())
    }

}

public protocol DataReader {
    
    typealias Element: UnsignedIntegerType

    func read(count: Int, queue: dispatch_queue_t, handler: DataReadResult<Element> -> Void)
    func readUntilEnd(queue queue: dispatch_queue_t, handler: DataReadResult<Element> -> Void)
    func close()
    
}

extension DataReader {

    public func readUntilEnd(queue queue: dispatch_queue_t, handler: DataReadResult<Element> -> Void) {
        read(Int.max, queue: queue, handler: handler)
    }

}
