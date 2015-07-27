//
//  ResourceTypes.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 4/1/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import Foundation
#if os(OSX)
    import AppKit.NSImage
#elseif os(iOS)
    import UIKit.UIImage
#endif

// MARK: URL Resource Types

public typealias OpaqueType = protocol<NSObjectProtocol, NSCopying, NSCoding>

public enum FileType: ResourceConvertible {
    
    case NamedPipe
    case CharacterSpecial
    case Directory
    case BlockSpecial
    case Regular
    case SymbolicLink
    case Socket
    case Unknown
    
    private init(string: String) {
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
    
    public init!(URLResource string: String) {
        self.init(string: string)
    }
    
    
}

#if os(OSX)
    
    private func ~=(inner: CFString!, outer: AnyObject?) -> Bool {
        if let outer: AnyObject = outer, inner = inner {
            return CFEqual(outer, inner) == 1
        }
        return false
    }
    
    public struct Quarantine: ResourceConvertible, ResourceRepresentable {
        
        /// A reason for quarantining an item.
        public enum Kind {
            
            case Unknown
            case WebDownload
            case OtherDownload
            case EmailAttachment
            case InstantMessageAttachment
            case CalendarEventAttachment
            case OtherAttachment
            
            private init(string: AnyObject?) {
                switch string {
                case kLSQuarantineTypeWebDownload: self = .WebDownload
                case kLSQuarantineTypeOtherDownload: self = .OtherDownload
                case kLSQuarantineTypeEmailAttachment: self = .EmailAttachment
                case kLSQuarantineTypeInstantMessageAttachment: self = .InstantMessageAttachment
                case kLSQuarantineTypeCalendarEventAttachment: self = .CalendarEventAttachment
                case kLSQuarantineTypeOtherAttachment: self = .OtherAttachment
                default: self = .Unknown
                }
            }
            
            private var stringValue: CFString? {
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
        
        private var dictionaryValue = [NSObject: AnyObject]()
        private init(dictionary: [NSObject: AnyObject]) {
            self.dictionaryValue = dictionary
        }
        
        /// The name of the quarantining agent (application or program). When
        /// setting quarantine properties, this value is set automatically to
        /// the current process name if not present.
        var agentName: String? {
            get { return dictionaryValue[kLSQuarantineAgentNameKey] as? String }
            set { dictionaryValue[kLSQuarantineAgentNameKey] = newValue }
        }
        
        /// The bundle identifier of the quarantining agent. When setting
        /// quarantine properties, this value is set automatically to the main
        /// bundle identifier of the current process if the key if not present.
        var agentBundleIdentifier: String? {
            get { return dictionaryValue[kLSQuarantineAgentBundleIdentifierKey] as? String }
            set { dictionaryValue[kLSQuarantineAgentBundleIdentifierKey] = newValue }
        }
        
        /// The date and time the item was quarantined. When setting quarantine
        /// properties, this value is set automatically to the current time if
        /// not present.
        var timestamp: NSDate? {
            get { return dictionaryValue[kLSQuarantineTimeStampKey] as? NSDate }
            set { dictionaryValue[kLSQuarantineTimeStampKey] = newValue }
        }
        
        /// A symbolic value identifying the why the item is quarantined.
        var kind: Kind {
            get { return Kind(string: dictionaryValue[kLSQuarantineTypeKey]) }
            set { dictionaryValue[kLSQuarantineTypeKey] = newValue.stringValue }
        }
        
        /// The URL from which the data for the quarantined item data was
        /// actually streamed or downloaded.
        var dataURL: NSURL? {
            get { return dictionaryValue[kLSQuarantineDataURLKey] as? NSURL }
            set { dictionaryValue[kLSQuarantineDataURLKey] = newValue }
        }
        
        /// The URL of the resource originally hosting the quarantined item,
        /// from the user's point of view.
        ///
        /// For web downloads, this property is the URL of the web page on
        /// which the user initiated the download.
        ///
        /// For attachments, this property is the URL of the resource to which
        /// the quarantined item was attached (e.g. the email message, calendar
        /// event, etc.).
        ///
        /// The origin URL may be a file URL for local resources, or a custom
        /// URL to which the quarantining application will respond when asked
        /// to open it. The quarantining application should respond by
        /// displaying the resource to the user.
        ///
        /// :note: The origin URL should not be set to the data URL, or the
        /// quarantining application may start downloading the file again if the 
        /// user choses to view the origin URL while resolving a quarantine.
        var originURL: NSURL? {
            get { return dictionaryValue[kLSQuarantineOriginURLKey] as? NSURL }
            set { dictionaryValue[kLSQuarantineOriginURLKey] = newValue }
        }
        
        public init() {
            self.init(dictionary: [:])
        }
        
        public init!(URLResource dictionary: [NSObject: AnyObject]) {
            self.init(dictionary: dictionary)
        }
        
        public var URLResourceValue: AnyObject? {
            return dictionaryValue.isEmpty ? NSNull() : dictionaryValue
        }
        
    }
    
#endif

public enum UbiquitousStatus: ResourceConvertible {
    
    case NotDownloaded
    case Downloaded
    case Current
    
    public init!(URLResource string: String) {
        switch string {
        case NSURLUbiquitousItemDownloadingStatusNotDownloaded: self = .NotDownloaded
        case NSURLUbiquitousItemDownloadingStatusDownloaded: self = .Downloaded
        default: self = .Current
        }
    }
    
}

#if os(OSX)
public typealias ImageType = NSImage
#elseif os(iOS)
public typealias ImageType = UIImage
#endif

@available(OSX 10.10, *)
public enum ThumbnailSize: ResourceConvertible {
    
    case W1024
    
    public init?(URLResource string: String) {
        switch string {
        case NSThumbnail1024x1024SizeKey: self = .W1024
        default: return nil
        }
    }
    
    public var URLResourceValue: String {
        switch self {
        case .W1024: return NSThumbnail1024x1024SizeKey
        }
    }
    
    static func readDictionary(dictionary: [String: ImageType]) -> [ThumbnailSize: ImageType]? {
        var ret = [ThumbnailSize : ImageType]()
        for (sizeKey, image) in dictionary {
            if let key = ThumbnailSize(URLResource: sizeKey) {
                ret[key] = (image as ImageType)
            }
        }
        return ret
    }
    
    static func writeDictionary(dictionary: [ThumbnailSize: ImageType]) -> AnyObject {
        var ret = [String: ImageType]()
        for (size, image) in dictionary {
            ret[size.URLResourceValue] = image
        }
        return ret
    }
    
}

// MARK: URL resource

extension UTI: ResourceConvertible {
    
    public init!(URLResource: String) {
        self.init(URLResource)
    }
    
}
