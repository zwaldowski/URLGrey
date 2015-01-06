// Playground - noun: a place where people can play

import Cocoa
import Dispatch
import URLGrey
import LlamaKit

let swift = UTI(preferredTag: .FilenameExtension("swift"))
let bundle = swift.declaringBundleURL

final class DispatchFileSource {
    
    private let channel: dispatch_io_t
    
    init(channel: dispatch_io_t) {
        self.channel = channel
    }
    
    convenience init(fileDescriptor fd: Int32, closeWhenDone: Bool = false) {
        let queue = dispatch_get_global_queue(0, 0)
        let channel = dispatch_io_create(DISPATCH_IO_STREAM, fd, queue) { error in
            if closeWhenDone {
                Darwin.close(fd)
            }
            
            assert(error == 0, "Unhandled error in dispatch file source: \(strerror(errno))")
        }
        self.init(channel: channel)
    }
    
    func read(#length: UInt, queue: dispatch_queue_t, completion: (done: Bool, result: Result<dispatch_data_t>) -> ()) {
        dispatch_io_read(channel, 0, length, queue) { (done, data, error) -> Void in
            if error != 0 {
                let error = NSError(domain: NSPOSIXErrorDomain, code: numericCast(error), userInfo: nil)
                completion(done: done, result: failure(error))
            } else {
                completion(done: done, result: success(data))
            }
        }
    }
    
    func close() {
        dispatch_io_close(channel, DISPATCH_IO_STOP)
    }
    
}

let testStr: StaticString = "test"
testStr.utf8Start
testStr.byteSize

//let d = Data(pointer: testStr.utf8Start, count: testStr.byteSize, owner: testStr)
