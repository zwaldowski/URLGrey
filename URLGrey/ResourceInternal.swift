//
//  ResourceInternal.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 10/21/14.
//  Copyright (c) 2014 Zachary Waldowski. All rights reserved.
//

import Foundation

// MARK: Internal Resource Meta-Types

/// Read-only values that can cross the Objective-C bridge (`String`, `Int`)
public struct _Readable<T: _ObjectiveCBridgeable>: ResourceReadable {
    
    public let key: String
    
    public static func read(input: AnyObject?) -> AnyResult<T> {
        switch input {
        case .Some(let ret as T):
            return success(ret)
        case .Some:
            return failure(error(code: URLError.ResourceReadConversion))
        case .None:
            return failure(error(code: URLError.ResourceReadUnavailable))
        }
    }
    
    public func read(input: AnyObject?) -> AnyResult<T> {
        return self.dynamicType.read(input)
    }
    
}

/// Read-only types that come out exactly as we want them (`NSURL`, `NSDate`)
public struct _ReadableObject<T: AnyObject>: ResourceReadable {
    
    public let key: String
    
    public static func read(input: AnyObject?) -> ObjectResult<T> {
        switch input {
        case .Some(let ret as T):
            return success(ret)
        case .Some:
            return failure(error(code: URLError.ResourceReadConversion))
        case .None:
            return failure(error(code: URLError.ResourceReadUnavailable))
        }
    }
    
    public func read(input: AnyObject?) -> ObjectResult<T> {
        return self.dynamicType.read(input)
    }
    
}

/// Read-only that must be converted after being bridged to some native type
/// (i.e., `String`->`URLGrey.UTI`)
public struct _ReadableConvert<T: ResourceReadableConvertible>: ResourceReadable {
    
    public let key: String
    
    public static func read(input: AnyObject?) -> AnyResult<T> {
        switch input {
        case .Some(let value as T.ResourceValue):
            if let ret = T(URLResource: value) {
                return success(ret)
            }
            return failure(error(code: URLError.ResourceReadConversion))
        case .Some:
            return failure(error(code: URLError.ResourceReadConversion))
        case .None:
            return failure(error(code: URLError.ResourceReadUnavailable))
        }
    }
    
    public func read(input: AnyObject?) -> AnyResult<T> {
        return self.dynamicType.read(input)
    }

}

/// Read-write values that can cross the Objective-C bridge (`String`, `Int`)
public struct _Writable<O: _ObjectiveCBridgeable, I: AnyObject>: ResourceReadable, ResourceWritable {
    
    public let key: String
    
    public func read(input: AnyObject?) -> AnyResult<O> {
        return _Readable<O>.read(input)
    }
    
    public func write(input: O) -> ObjectResult<AnyObject> {
        if let ret = input as? I {
            return success(ret)
        }
        return failure(error(code: URLError.ResourceWriteConversion))
    }
    
}

/// Read-write types that come out exactly as we want them (`NSURL`, `NSDate`)
public struct _WritableObject<T: AnyObject>: ResourceReadable, ResourceWritable {

    public let key: String
    
    public func read(input: AnyObject?) -> ObjectResult<T> {
        return _ReadableObject<T>.read(input)
    }
    
    public func write(input: T) -> ObjectResult<AnyObject> {
        return success(input)
    }

}

/// Read-only that must be converted after being bridged to some native type
/// (i.e., `String`->`URLGrey.UTI`)
public struct _WritableConvert<T: ResourceWritableConvertible>: ResourceReadable, ResourceWritable {
    
    public let key: String
    
    public func read(input: AnyObject?) -> AnyResult<T> {
        return _ReadableConvert<T>.read(input)
    }
    
    public func write(input: T) -> ObjectResult<AnyObject> {
        if let ret: AnyObject = input.URLResourceValue {
            return success(ret)
        }
        return failure(error(code: URLError.ResourceWriteConversion))
    }
    
}

public struct _WritableOf<O, I: _ObjectiveCBridgeable>: ResourceReadable, ResourceWritable {
    
    public let key: String
    public let reading: I -> O?
    public let writing: O -> AnyObject
    
    public func read(input: AnyObject?) -> AnyResult<O> {
        switch input {
        case .Some(let value as I):
            if let ret = reading(value) {
                return success(ret)
            }
            return failure(error(code: URLError.ResourceReadConversion))
        case .Some:
            return failure(error(code: URLError.ResourceReadConversion))
        case .None:
            return failure(error(code: URLError.ResourceReadUnavailable))
        }
    }
    
    public func write(input: O) -> ObjectResult<AnyObject> {
        return success(writing(input))
    }
    
}

// MARK: Convertible Private Extensions

private extension FileType {
    
    init(string: String) {
        switch string {
        case NSURLFileResourceTypeNamedPipe: self = .NamedPipe
        case NSURLFileResourceTypeCharacterSpecial: self = .CharacterSpecial
        case NSURLFileResourceTypeDirectory: self = .Directory
        case NSURLFileResourceTypeBlockSpecial: self = .BlockSpecial
        case NSURLFileResourceTypeRegular: self = .Regular
        case NSURLFileResourceTypeSymbolicLink: self = .SymbolicLink
        case NSURLFileResourceTypeSocket: self = .Socket
        default: self = .Unknown
        }
    }
    
}

#if os(OSX)
    
    private extension Quarantine {
        
        init(dictionary: [NSObject: AnyObject]) {
            agentName = dictionary[kLSQuarantineAgentNameKey] as? String
            agentBundleIdentifier = dictionary[kLSQuarantineAgentBundleIdentifierKey] as? String
            timestamp = dictionary[kLSQuarantineTimeStampKey] as? NSDate
            kind = Kind(string: dictionary[kLSQuarantineTypeKey] as! String)
            dataURL = dictionary[kLSQuarantineDataURLKey] as? NSURL
            originURL = dictionary[kLSQuarantineOriginURLKey] as? NSURL
        }
        
        var dictionaryValue: [String: AnyObject] {
            var dictionary = [String: AnyObject]()
            dictionary[kLSQuarantineAgentNameKey as! String] = agentName
            dictionary[kLSQuarantineAgentBundleIdentifierKey as! String] = agentBundleIdentifier
            dictionary[kLSQuarantineTimeStampKey as! String] = timestamp
            dictionary[kLSQuarantineTypeKey as! String] = kind.stringValue
            dictionary[kLSQuarantineDataURLKey as! String] = dataURL
            dictionary[kLSQuarantineOriginURLKey as! String] = originURL
            return dictionary
        }
        
    }
    
    private extension Quarantine.Kind {
        
        init(string: String) {
            switch string {
            case kLSQuarantineTypeWebDownload as! String: self = .WebDownload
            case kLSQuarantineTypeOtherDownload as! String: self = .OtherDownload
            case kLSQuarantineTypeEmailAttachment as! String: self = .EmailAttachment
            case kLSQuarantineTypeInstantMessageAttachment as! String: self = .InstantMessageAttachment
            case kLSQuarantineTypeCalendarEventAttachment as! String: self = .CalendarEventAttachment
            case kLSQuarantineTypeOtherAttachment as! String: self = .OtherAttachment
            default: self = .Unknown
            }
        }
        
        var stringValue: String? {
            switch self {
            case .Unknown: return nil
            case .WebDownload: return kLSQuarantineTypeWebDownload as String
            case .OtherDownload: return kLSQuarantineTypeOtherDownload as String
            case .EmailAttachment: return kLSQuarantineTypeEmailAttachment as String
            case .InstantMessageAttachment: return kLSQuarantineTypeInstantMessageAttachment as String
            case .CalendarEventAttachment: return kLSQuarantineTypeCalendarEventAttachment as String
            case .OtherAttachment: return kLSQuarantineTypeOtherAttachment as String
            }
        }
        
    }
    
#endif

private extension UbiquitousStatus {
    
    init(string: String) {
        switch string {
        case NSURLUbiquitousItemDownloadingStatusNotDownloaded: self = .NotDownloaded
        case NSURLUbiquitousItemDownloadingStatusDownloaded: self = .Downloaded
        default: self = .Current
        }
    }
    
}

private extension ThumbnailSize {
    
    init?(URLResource string: String) {
        switch string {
        case NSThumbnail1024x1024SizeKey: self = .W1024
        default: return nil
        }
    }
    
    var URLResourceValue: String {
        switch self {
        case .W1024: return NSThumbnail1024x1024SizeKey
        }
    }
    
}

// MARK: Convertible Public Extensions

extension UTI: ResourceReadableConvertible {
    
    public init!(URLResource: String) {
        self.init(URLResource)
    }
    
}

extension FileType: ResourceReadableConvertible {
    
    public init!(URLResource string: String) {
        self.init(string: string)
    }
    
}

#if os(OSX)
    
    extension Quarantine: ResourceWritableConvertible {

        public init?(URLResource: AnyObject) {
            if let dictionary = URLResource as? [NSObject: AnyObject] {
                self.init(dictionary: dictionary)
            } else {
                return nil
            }
        }
        
        public var URLResourceValue: AnyObject? {
            let dictionary = dictionaryValue
            if dictionary.isEmpty {
                return NSNull()
            }
            return dictionary
        }
        
    }
    
#endif

extension UbiquitousStatus: ResourceReadableConvertible {
    
    public init!(URLResource: String) {
        self.init(string: URLResource)
    }
    
}

// MARK: Custom Thumbnail Dictionary Resource

func ThumbnailDictionaryRead(dictionary: [String: ImageType]) -> [ThumbnailSize: ImageType]? {
    var ret = [ThumbnailSize : ImageType]()
    for (sizeKey, image) in dictionary {
        if let key = ThumbnailSize(URLResource: sizeKey) {
            ret[key] = (image as ImageType)
        }
    }
    return ret
}

func ThumbnailDictionaryWrite(dictionary: [ThumbnailSize: ImageType]) -> AnyObject {
    var ret = [String: ImageType]()
    for (size, image) in dictionary {
        ret[size.URLResourceValue] = image
    }
    return ret
}
