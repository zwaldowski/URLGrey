//
//  UTI.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 10/21/14.
//  Copyright (c) 2014 Zachary Waldowski. All rights reserved.
//

import Foundation
#if os(OSX)
    import CoreServices
#elseif os(iOS)
    import MobileCoreServices
#endif

public struct UTI {
    
    private let identifier: String
    
    public init(_ identifier: String) {
        self.identifier = identifier
    }
    
    public func conformsTo(other: UTI) -> Bool {
        return UTTypeConformsTo(identifier, other.identifier) == 1
    }
    
    public var declared: Bool {
        return UTTypeIsDeclared(identifier) == 1
    }
    
    public var dynamic: Bool {
        return UTTypeIsDynamic(identifier) == 1
    }
    
    public var declaringBundleURL: NSURL? {
        return UTTypeCopyDeclaringBundleURL(identifier)?.takeRetainedValue()
    }
    
}

// MARK: Printable

extension UTI: Printable {
    
    public var description: String {
        return UTTypeCopyDescription(identifier).takeRetainedValue()
    }
    
}

// MARK: Equatable, Hashable

public func ==(a: UTI, b: UTI) -> Bool {
    return UTTypeEqual(a.identifier, b.identifier) == 1
}

extension UTI: Hashable {
    
    public var hashValue: Int {
        return identifier.hashValue
    }
    
}

// MARK: OSType compatibility (OS X)

#if os(OSX)

    private extension OSType {
        
        init?(string: String!) {
            let type = UTGetOSTypeFromString(string)
            if (type == 0) {
                self = type
            } else {
                return nil
            }
        }
        
        var stringValue: String {
            return UTCreateStringForOSType(self)!.takeRetainedValue()
        }
        
    }

#endif

// MARK: Tag Classes (Private, OS X bits)

private extension UTI {

    enum TagKind {
        case FilenameExtension
        case MIME
        #if os(OSX)
            case Pasteboard
            case Legacy
        #endif
        
        var stringValue: String {
            #if os(OSX)
                switch self {
                case .FilenameExtension: return kUTTagClassFilenameExtension
                case .MIME: return kUTTagClassMIMEType
                case .Pasteboard: return kUTTagClassNSPboardType
                case .Legacy: return kUTTagClassOSType
                }
            #else
                switch self {
                case .FilenameExtension: return kUTTagClassFilenameExtension
                case .MIME: return kUTTagClassMIMEType
                }
            #endif
        }
    }
    
    func preferredTag(kind: TagKind) -> String? {
        return UTTypeCopyPreferredTagWithClass(identifier, kind.stringValue)?.takeRetainedValue()
    }
    
    func allTags(kind: TagKind) -> [String]? {
        return UTTypeCopyAllTagsWithClass(identifier, kind.stringValue)?.takeRetainedValue() as? [String]
    }
    
}

// MARK: Tags (Public, OS X bits)

public extension UTI {
    
    public enum Tag {
        case FilenameExtension(String)
        case MIME(String)
        #if os(OSX)
            case Pasteboard(String)
            case Legacy(OSType)
        #endif
        
        private init?(kind: TagKind, value: String) {
            #if os(OSX)
                switch kind {
                case .FilenameExtension: self = .FilenameExtension(value)
                case .MIME: self = .MIME(value)
                case .Pasteboard: self = .Pasteboard(value)
                case .Legacy:
                    if let osType = OSType(string: value) {
                        self = .Legacy(osType)
                    } else {
                        return nil
                    }
                default: return nil
                }
            #else
                switch kind {
                case .FilenameExtension: self = .FilenameExtension(value)
                case .MIME: self = .MIME(value)
                default: return nil
                }
            #endif
        }
        
        var kindValue: String {
            #if os(OSX)
                switch self {
                case .FilenameExtension: return kUTTagClassFilenameExtension
                case .MIME: return kUTTagClassMIMEType
                case .Pasteboard: return kUTTagClassNSPboardType
                case .Legacy: return kUTTagClassOSType
                }
            #else
                switch self {
                case .FilenameExtension: return kUTTagClassFilenameExtension
                case .MIME: return kUTTagClassMIMEType
                }
            #endif
        }
        
        var stringValue: String {
            #if os(OSX)
                switch self {
                case .FilenameExtension(let ext): return ext
                case .MIME(let mime): return mime
                case .Pasteboard(let UTI): return UTI
                case .Legacy(let osType): return osType.stringValue
                }
            #else
                switch self {
                case .FilenameExtension(let ext): return ext
                case .MIME(let mime): return mime
                }
            #endif
        }
        
    }
    
    public static func preferredIdentifier(tag: Tag, conformingTo parent: UTI? = nil) -> UTI? {
        let parentUTI = parent?.identifier
        if let preferred = UTTypeCreatePreferredIdentifierForTag(tag.kindValue, tag.stringValue, parentUTI)?.takeRetainedValue() {
            return UTI(preferred)
        } else {
            return nil
        }
    }
    
    public static func allIdentifiers(tag: Tag, conformingTo parent: UTI? = nil) -> [UTI]? {
        let parentUTI = parent?.identifier
        if let all = UTTypeCreateAllIdentifiersForTag(tag.kindValue, tag.stringValue, parentUTI)?.takeRetainedValue() as? [String] {
            return all.map { UTI($0) }
        } else {
            return nil
        }
    }
    
    public var preferredPathExtension: String? {
        return preferredTag(.FilenameExtension)
    }
    
    public var preferredMIMEType: String? {
        return preferredTag(.MIME)
    }
    
    public var pathExtensions: [String]? {
        return allTags(.FilenameExtension)
    }
    
    public var MIMETypes: [String]? {
        return allTags(.MIME)
    }
    
    #if os(OSX)
    
        public var preferredPasteboardType: String? {
            return preferredTag(.Pasteboard)
        }
        
        public var preferredLegacyType: OSType? {
            return OSType(string: preferredTag(.Legacy))
        }
        
        public var pasteboardTypes: [String]? {
            return allTags(.Pasteboard)
        }
        
        public var preferredLegacyTypes: [OSType]? {
            return allTags(.Legacy)?.map { OSType(string: $0)! }
        }
    
    #endif
    
}
