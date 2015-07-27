//
//  URLResourceTypes.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 4/1/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import Foundation

#if os(OSX)
    import AppKit.NSImage
    public typealias ImageType = NSImage
#elseif os(iOS) || os(watchOS)
    import UIKit.UIImage
    public typealias ImageType = UIImage
#endif

// MARK: URL Resource Types

public typealias OpaqueType = protocol<NSObjectProtocol, NSCopying, NSCoding>

public enum FileClass: URLResourceConvertible {
    
    case NamedPipe
    case CharacterSpecial
    case Directory
    case BlockSpecial
    case Regular
    case SymbolicLink
    case Socket
    case Unknown
    
    public init(URLResource string: String) throws {
        switch string {
        case NSURLFileResourceTypeNamedPipe:
            self = .NamedPipe
        case NSURLFileResourceTypeCharacterSpecial:
            self = .CharacterSpecial
        case NSURLFileResourceTypeDirectory:
            self = .Directory
        case NSURLFileResourceTypeBlockSpecial:
            self = .BlockSpecial
        case NSURLFileResourceTypeRegular:
            self = .Regular
        case NSURLFileResourceTypeSymbolicLink:
            self = .SymbolicLink
        case NSURLFileResourceTypeSocket:
            self = .Socket
        case _:
            throw URLResourceError.InvalidValue
        }
    }
    
}

#if os(OSX)
    
    private func ~=(inner: CFString, outer: AnyObject?) -> Bool {
        guard let outer = outer as? String else { return false }
        return outer == (inner as String)
    }
    
    public struct Quarantine: URLResourceRepresentable {
        
        /// A reason for quarantining an item.
        public enum Kind {
            
            case Unknown
            case WebDownload
            case OtherDownload
            case EmailAttachment
            case InstantMessageAttachment
            case CalendarEventAttachment
            case OtherAttachment
            
            private init(_ object: AnyObject?) {
                switch object {
                case kLSQuarantineTypeWebDownload:
                    self = .WebDownload
                case kLSQuarantineTypeOtherDownload:
                    self = .OtherDownload
                case kLSQuarantineTypeEmailAttachment:
                    self = .EmailAttachment
                case kLSQuarantineTypeInstantMessageAttachment:
                    self = .InstantMessageAttachment
                case kLSQuarantineTypeCalendarEventAttachment:
                    self = .CalendarEventAttachment
                case kLSQuarantineTypeOtherAttachment:
                    self = .OtherAttachment
                case _:
                    self = .Unknown
                }
            }
            
            private var objectValue: NSString? {
                switch self {
                case .Unknown:
                    return nil
                case .WebDownload:
                    return kLSQuarantineTypeWebDownload
                case .OtherDownload:
                    return kLSQuarantineTypeOtherDownload
                case .EmailAttachment:
                    return kLSQuarantineTypeEmailAttachment
                case .InstantMessageAttachment:
                    return kLSQuarantineTypeInstantMessageAttachment
                case .CalendarEventAttachment:
                    return kLSQuarantineTypeCalendarEventAttachment
                case .OtherAttachment:
                    return kLSQuarantineTypeOtherAttachment
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
            get { return Kind(dictionaryValue[kLSQuarantineTypeKey]) }
            set { dictionaryValue[kLSQuarantineTypeKey] = newValue.objectValue }
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
            self.dictionaryValue = [:]
        }
        
        public init(URLResource dictionary: [NSObject: AnyObject]) throws {
            self.dictionaryValue = dictionary
        }
        
        public var URLResourceValue: AnyObject {
            return dictionaryValue.isEmpty ? NSNull() : dictionaryValue
        }
        
    }
    
#endif

public enum UbiquitousStatus: URLResourceConvertible {
    
    case NotDownloaded
    case Downloaded
    case Current
    
    public init(URLResource string: String) throws {
        switch string {
        case NSURLUbiquitousItemDownloadingStatusNotDownloaded:
            self = .NotDownloaded
        case NSURLUbiquitousItemDownloadingStatusDownloaded:
            self = .Downloaded
        case NSURLUbiquitousItemDownloadingStatusCurrent:
            self = .Current
        case _:
            throw URLResourceError.InvalidValue
        }
    }
    
}

@available(OSX 10.10, iOS 8.0, watchOS 2.0, *)
public enum ThumbnailSize: URLResourceRepresentable {
    
    case W1024
    
    public init(URLResource string: String) throws {
        switch string {
        case NSThumbnail1024x1024SizeKey:
            self = .W1024
        case _:
            throw URLResourceError.InvalidValue
        }
    }
    
    public var URLResourceValue: NSString {
        switch self {
        case .W1024:
            return NSThumbnail1024x1024SizeKey
        }
    }
    
}

// MARK: URL resource

extension UTI: URLResourceConvertible {
    
    public init(URLResource: String) throws {
        self.init(URLResource)
    }
    
}

#if os(iOS) || os(watchOS)
    
    @available(iOS 9.0, watchOS 2.0, *)
    public enum FileProtection: URLResourceRepresentable {
        
        case None
        case Complete
        case CompleteUnlessOpen
        case CompleteUntilFirstUserAuthentication
        
        public init(URLResource string: String) throws {
            switch string {
            case NSURLFileProtectionNone:
                self = .None
            case NSURLFileProtectionComplete:
                self = .Complete
            case NSURLFileProtectionCompleteUnlessOpen:
                self = .CompleteUnlessOpen
            case NSURLFileProtectionCompleteUntilFirstUserAuthentication:
                self = .CompleteUntilFirstUserAuthentication
            case _:
                throw URLResourceError.InvalidValue
            }
        }
        
        public var URLResourceValue: NSString {
            switch self {
            case .None:
                return NSURLFileProtectionNone
            case .Complete:
                return NSURLFileProtectionComplete
            case .CompleteUnlessOpen:
                return NSURLFileProtectionCompleteUnlessOpen
            case .CompleteUntilFirstUserAuthentication:
                return NSURLFileProtectionCompleteUntilFirstUserAuthentication
            }
        }
        
    }
    
#endif
