//
//  PipeSource.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 1/10/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import Dispatch
import LlamaKit

public protocol PipeSource {
    
    typealias Data: ByteCollection

    func read(#length: Int, queue: dispatch_queue_t, handler: Result<Data> -> ())
    func readUntilEnd(#queue: dispatch_queue_t, handler: Result<Data> -> ())
    func close()
    
}
