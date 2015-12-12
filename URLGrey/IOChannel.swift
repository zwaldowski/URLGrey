//
//  IOChannel.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 1/10/15.
//  Copyright © 2014-2015. Some rights reserved.
//

import Dispatch

public final class IOChannel<Element: UnsignedIntegerType>: DataReader {
    
    private let channel: dispatch_io_t
    private var partialData = Data<UInt8>()
    
    private init(channel: dispatch_io_t) {
        self.channel = channel
    }

    public func read(count: Int, queue: dispatch_queue_t, handler: DataReadResult<Element> -> Void) {
        let length = Data<Element>.toBytes(count)
        let progress = NSProgress.currentProgress().map { _ in NSProgress(totalUnitCount: numericCast(length)) }
        if let progress = progress {
            progress.kind = NSProgressKindFile
            progress.setUserInfoObject(NSProgressFileOperationKindReceiving, forKey: NSProgressFileOperationKindKey)
            progress.cancellationHandler = self.close
        }
        
        dispatch_io_read(channel, 0, length, queue) { (done, dispatchData, errno) in
            let userCancelled = progress?.cancelled ?? false
            switch (userCancelled, done, errno) {
            case (false, true, 0):
                handler(.Success(Data()))
            case (false, false, 0):
                let data = Data<Element>(dispatchData, partial: &self.partialData)
                progress?.becomeCurrentWithPendingUnitCount(numericCast(data.count))
                handler(.Success(data))
                progress?.resignCurrent()
            case (true, _, _):
                handler(.Failure(IOError.UserCancelled))
            case (_, _, ECANCELED):
                handler(.Failure(IOError.Closed))
            case (_, _, let err):
                if let error = POSIXError(rawValue: err) {
                    handler(.Failure(error))
                } else {
                    handler(.Failure(IOError.Unknown))
                }
            }
        }
    }
    
    public func close() {
        dispatch_io_close(channel, DISPATCH_IO_STOP)
    }
    
}

private var IOChannelQueue: dispatch_queue_t {
    #if os(OSX)
        guard #available(OSX 10.10, *) else {
            return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
        }
    #endif
    return dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
}

extension IOChannel {
    
    public convenience init(fileDescriptor fd: Int32, closeWhenDone: Bool = false, queue: dispatch_queue_t = IOChannelQueue) {
        let queue = dispatch_get_global_queue(0, 0)
        let channel = dispatch_io_create(DISPATCH_IO_STREAM, fd, queue) { error in
            if closeWhenDone {
                Darwin.close(fd)
            }
            
            assert(error == 0, "Unhandled error in dispatch file source: \(strerror(errno))")
        }
        
        self.init(channel: channel)
    }
    
    public convenience init(URL: NSURL, queue: dispatch_queue_t = IOChannelQueue) {
        let channel = dispatch_io_create_with_path(DISPATCH_IO_STREAM, URL.fileSystemRepresentation, O_RDONLY, 0, queue) { error in
            assert(error == 0, "Unhandled error in dispatch file source: \(strerror(error))")
        }
        self.init(channel: channel)
    }
    
}
