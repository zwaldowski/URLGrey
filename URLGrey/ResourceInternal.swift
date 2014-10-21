//
//  ResourceInternal.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 10/21/14.
//  Copyright (c) 2014 Zachary Waldowski. All rights reserved.
//

import Foundation
#if os(OSX)
    import AppKit.NSImage
#elseif os(iOS)
    import UIKit.UIImage
#endif

// MARK: Internal Resource Meta-Types

public struct _Readable<InOut>: ReadableResource {
    typealias InType = InOut
    typealias OutType = InOut
    
    public var read: (InType -> OutType?) { return { $0 } }
    
    public let key: String
}

public struct _Writable<InOut>: WritableResource {
    typealias InType = InOut
    typealias OutType = InOut
    
    public var read: (InType -> OutType?) { return { $0 } }
    public var write: (OutType -> InType!) { return { $0 } }
    
    public let key: String
}

public struct _MapReadable<InOut: ReadableResourceConvertible>: ReadableResource {
    typealias InType = InOut.ReadableResourceType
    typealias OutType = InOut
    
    public var read: (InType -> OutType?) { return { OutType(URLResource: $0) } }

    public let key: String
}

public struct _MapWritable<InOut: WritableResourceConvertible>: WritableResource {
    typealias InType = InOut.ReadableResourceType
    typealias OutType = InOut
    
    public var read: (InType -> OutType?) { return { OutType(URLResource: $0) } }
    public var write: (OutType -> InType!) { return { $0.resourceValue } }
    
    public let key: String
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
            kind = Kind(string: dictionary[kLSQuarantineTypeKey] as? String)
            dataURL = dictionary[kLSQuarantineDataURLKey] as? NSURL
            originURL = dictionary[kLSQuarantineOriginURLKey] as? NSURL
        }
        
        var dictionaryValue: [String: AnyObject] {
            var dictionary = [String: AnyObject]()
            dictionary[kLSQuarantineAgentNameKey] = agentName
            dictionary[kLSQuarantineAgentBundleIdentifierKey] = agentBundleIdentifier
            dictionary[kLSQuarantineTimeStampKey] = timestamp
            dictionary[kLSQuarantineTypeKey] = kind.stringValue
            dictionary[kLSQuarantineDataURLKey] = dataURL
            dictionary[kLSQuarantineOriginURLKey] = originURL
            return dictionary
        }
        
    }
    
    private extension Quarantine.Kind {
        
        init(string: String?) {
            if let string = string {
                switch string {
                case kLSQuarantineTypeWebDownload: self = .WebDownload
                case kLSQuarantineTypeOtherDownload: self = .OtherDownload
                case kLSQuarantineTypeEmailAttachment: self = .EmailAttachment
                case kLSQuarantineTypeInstantMessageAttachment: self = .InstantMessageAttachment
                case kLSQuarantineTypeCalendarEventAttachment: self = .CalendarEventAttachment
                case kLSQuarantineTypeOtherAttachment: self = .OtherAttachment
                default: self = .Unknown
                }
            } else {
                self = .Unknown
            }
        }
        
        var stringValue: String? {
            switch self {
            case .Unknown: return nil
            case .WebDownload: return kLSQuarantineTypeWebDownload
            case .OtherDownload: return kLSQuarantineTypeOtherDownload
            case .EmailAttachment: return kLSQuarantineTypeEmailAttachment
            case .InstantMessageAttachment: return kLSQuarantineTypeInstantMessageAttachment
            case .CalendarEventAttachment: return kLSQuarantineTypeCalendarEventAttachment
            case .OtherAttachment: return kLSQuarantineTypeOtherAttachment
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
    
    init?(string: String) {
        switch string {
        case NSThumbnail1024x1024SizeKey: self = .W1024H1024
        default: return nil
        }
    }
    
    var stringValue: String {
        switch self {
        case .W1024H1024: return NSThumbnail1024x1024SizeKey
        }
    }
    
}

// MARK: Convertible Public Extensions

extension UTI: ReadableResourceConvertible {
    
    public init!(URLResource: String) {
        self.init(URLResource)
    }
    
}

extension FileType: ReadableResourceConvertible {
    
    public init!(URLResource string: String) {
        self.init(string: string)
    }
    
}

#if os(OSX)
    
    extension Quarantine: WritableResourceConvertible {

        public init?(URLResource: AnyObject) {
            if let dictionary = URLResource as? NSDictionary {
                self.init(dictionary: dictionary)
            } else {
                return nil
            }
        }
        
        public var resourceValue: AnyObject! {
            let dictionary = dictionaryValue
            if dictionary.isEmpty {
                return NSNull()
            }
            return dictionary
        }
        
    }
    
#endif

extension UbiquitousStatus: ReadableResourceConvertible {
    
    public init!(URLResource: String) {
        self.init(string: URLResource)
    }
    
}

// MARK: Custom Thumbnail Dictionary Resource Meta-Type

public struct _WritableThumbnailDictionary: WritableResource {
    public typealias InType = [String : ImageType]
    public typealias OutType = ThumbnailDictionary
    
    public var read: (InType -> OutType?) {
        return {
            var ret = OutType()
            for (sizeKey, image) in $0 {
                if let key = ThumbnailSize(string: sizeKey) {
                    ret[key] = (image as ImageType)
                }
            }
            return ret
        }
    }
    
    public var write: (OutType -> InType!) {
        return {
            var ret = InType()
            for (size, image) in $0 {
                ret[size.stringValue] = image
            }
            return ret
        }
    }
    
    public let key: String
}
