//
//  PipeSource.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 1/10/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import Dispatch

public protocol PipeSource {

    func read(#length: Int, queue: dispatch_queue_t, handler: AnyResult<Data> -> ())
    func readUntilEnd(#queue: dispatch_queue_t, handler: AnyResult<Data> -> ())
    func close()
    
}
