//
//  DataReader.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 1/10/15.
//  Copyright © 2014-2015. Some rights reserved.
//

import Dispatch
import Lustre

public protocol DataReader {
    
    typealias Element: UnsignedIntegerType

    func read(count count: Int?, queue: dispatch_queue_t, handler: Result<Data<Element>> -> ())
    func readUntilEnd(queue queue: dispatch_queue_t, handler: Result<Data<Element>> -> ())
    func close()
    
}
