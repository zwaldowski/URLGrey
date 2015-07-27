//
//  IOChannel.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 1/10/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import Dispatch
import Foundation
import Lustre

public struct IOChannel: PipeSource {
    
    private let channel: dispatch_io_t
    
    private init(channel: dispatch_io_t) {
        self.channel = channel
    }
    
    public init(fileDescriptor fd: Int32, closeWhenDone: Bool = false) {
        let queue = dispatch_get_global_queue(0, 0)
        let channel = dispatch_io_create(DISPATCH_IO_STREAM, fd, queue) { error in
            if closeWhenDone {
                Darwin.close(fd)
            }
            
            assert(error == 0, "Unhandled error in dispatch file source: \(strerror(errno))")
        }
        
        self.init(channel: channel)
    }
    
    public func readUntilEnd(queue queue: dispatch_queue_t, handler: Result<Data> -> ()) {
        read(queue: queue, handler: handler)
    }
    
    public func read(length length: Int = Int.max, queue: dispatch_queue_t, handler: Result<Data> -> ()) {
        let progress = NSProgress.currentProgress().map { _ in NSProgress(totalUnitCount: Int64(length)) }
        progress?.kind = NSProgressKindFile
        progress?.setUserInfoObject(NSProgressFileOperationKindReceiving, forKey: NSProgressFileOperationKindKey)
        progress?.cancellationHandler = {
            self.close()
        }
        
        dispatch_io_read(channel, 0, length, queue) { (done, dispatchData, posixError) -> Void in
            let userCancelled = progress?.cancelled ?? false
            switch (userCancelled, done, posixError) {
            case (true, _, _):
                handler(Result.Failure(IOError.UserCancelled))
            case (false, true, 0):
                handler(Result.Success(Data()))
            case (false, false, 0):
                let data = Data(dispatchData)
                progress?.becomeCurrentWithPendingUnitCount(Int64(data.count))
                handler(Result.Success(data))
                progress?.resignCurrent()
            case (false, _, ECANCELED):
                handler(Result.Failure(IOError.Closed))
            case (false, _, let posixCode):
                if let error = POSIXError(rawValue: posixCode) {
                    handler(Result.Failure(error))
                } else {
                    handler(Result.Failure(IOError.Read))
                }
            }
        }
    }
    
    public func close() {
        dispatch_io_close(channel, DISPATCH_IO_STOP)
    }
    
}
