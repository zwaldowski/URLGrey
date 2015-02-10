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

// MARK: Legacy

extension UTI {

    public init(_ legacyIdentifier: CFString!) {
        self.identifier = legacyIdentifier as String
    }

}

// MARK: Printable

extension UTI: Printable {
    
    public var description: String {
        if dynamic {
            return "Dynamic type (\(identifier))"
        }
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

// MARK: Tag Classes (Private)

private extension UTI {
    
    func preferredTag(kind: String) -> String? {
        return UTTypeCopyPreferredTagWithClass(identifier, kind)?.takeRetainedValue()
    }
    
    func allTags(kind: String) -> [String]? {
        return UTTypeCopyAllTagsWithClass(identifier, kind)?.takeRetainedValue() as? [String]
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
        
        private var kindValue: String {
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
        
        private var stringValue: String {
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
    
    public init!(preferredTag tag: Tag, conformingTo parent: UTI? = nil) {
        let parentUTI = parent?.identifier
        if let preferredIdentifier = UTTypeCreatePreferredIdentifierForTag(tag.kindValue, tag.stringValue, parentUTI)?.takeRetainedValue() {
            self.init(preferredIdentifier)
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
        return preferredTag(kUTTagClassFilenameExtension)
    }
    
    public var preferredMIMEType: String? {
        return preferredTag(kUTTagClassMIMEType)
    }
    
    public var pathExtensions: [String]? {
        return allTags(kUTTagClassFilenameExtension)
    }
    
    public var MIMETypes: [String]? {
        return allTags(kUTTagClassMIMEType)
    }
    
    #if os(OSX)
    
        public var preferredPasteboardType: String? {
            return preferredTag(kUTTagClassNSPboardType)
        }
        
        public var preferredLegacyType: OSType? {
            return preferredTag(kUTTagClassOSType).map { OSType(string: $0)! }
        }
        
        public var pasteboardTypes: [String]? {
            return allTags(kUTTagClassNSPboardType)
        }
        
        public var preferredLegacyTypes: [OSType]? {
            return allTags(kUTTagClassOSType)?.map { OSType(string: $0)! }
        }
    
    #endif
    
}
