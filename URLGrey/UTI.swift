//
//  UTI.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 10/21/14.
//  Copyright © 2014-2015. Some rights reserved.
//

import Foundation
#if os(OSX)
    import CoreServices
#elseif os(iOS) || os(watchOS)
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
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return !dynamic && declaringBundleURL != nil
            }
        #endif

        return UTTypeIsDeclared(identifier) == 1
    }
    
    public var dynamic: Bool {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return identifier.hasPrefix("dyn.")
            }
        #endif

        return UTTypeIsDynamic(identifier) == 1
    }
    
    public var declaringBundleURL: NSURL? {
        return UTTypeCopyDeclaringBundleURL(identifier)?.takeRetainedValue()
    }
    
}

// MARK: Legacy

extension UTI {

    public init(_ legacyIdentifier: CFString) {
        self.identifier = legacyIdentifier as String
    }

}

// MARK: Printable

extension UTI: CustomStringConvertible {
    
    public var description: String {
        guard !dynamic else {
            return "Dynamic type (\(identifier))"
        }

        guard let description = UTTypeCopyDescription(identifier)?.takeRetainedValue() else {
            return "public.unknown"
        }

        return description as String
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
        
        init?(fourCharString string: String) {
            let type = UTGetOSTypeFromString(string)
            guard type != 0 else { return nil }
            self = type
        }
        
    }

#endif

// MARK: Tag Classes (Private)

private extension UTI {
    
    func preferredTag(kind: CFString) -> String? {
        guard let cfString = UTTypeCopyPreferredTagWithClass(identifier, kind)?.takeRetainedValue() else { return nil }
        return cfString as String
    }
    
    func allTags(kind: CFString) -> [String] {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return preferredTag(kind).map { [ $0 ] } ?? []
            }
        #endif
        guard let cfTags = UTTypeCopyAllTagsWithClass(identifier, kind)?.takeRetainedValue() else { return [] }
        return lazy(cfTags as [AnyObject]).map { $0 as! String }
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
        
        private var kindValue: CFString {
            #if os(OSX)
                switch self {
                case .FilenameExtension:
                    return kUTTagClassFilenameExtension
                case .MIME:
                    return kUTTagClassMIMEType
                case .Pasteboard:
                    return kUTTagClassNSPboardType
                case .Legacy:
                    return kUTTagClassOSType
                }
            #else
                switch self {
                case .FilenameExtension:
                    return kUTTagClassFilenameExtension
                case .MIME:
                    return kUTTagClassMIMEType
                }
            #endif
        }
        
        private var stringValue: String {
            #if os(OSX)
                switch self {
                case .FilenameExtension(let ext):
                    return ext
                case .MIME(let mime):
                    return mime
                case .Pasteboard(let UTI):
                    return UTI
                case .Legacy(let osType):
                    return UTCreateStringForOSType(osType).takeRetainedValue() as String
                }
            #else
                switch self {
                case .FilenameExtension(let ext):
                    return ext
                case .MIME(let mime):
                    return mime
                }
            #endif
        }
        
    }
    
    public init!(preferredTag tag: Tag, conformingTo parent: UTI? = nil) {
        let parentUTI = parent?.identifier
        guard let UTI = UTTypeCreatePreferredIdentifierForTag(tag.kindValue, tag.stringValue, parentUTI)?.takeRetainedValue() else {
            return nil
        }
        self.init(UTI)
    }
    
    public static func allIdentifiersForTag(tag: Tag, conformingTo parent: UTI? = nil) -> AnyRandomAccessCollection<UTI> {
        let parentUTI = parent?.identifier
        guard let cfUTIs = UTTypeCreateAllIdentifiersForTag(tag.kindValue, tag.stringValue, parentUTI)?.takeRetainedValue() else {
            return AnyRandomAccessCollection(EmptyCollection())
        }
        let lazyUTIs = lazy(cfUTIs as [AnyObject]).map(unsafeDowncast).map(UTI.init)
        return AnyRandomAccessCollection(lazyUTIs)
    }
    
    public var preferredPathExtension: String? {
        return preferredTag(kUTTagClassFilenameExtension)
    }
    
    public var pathExtensions: [String] {
        return allTags(kUTTagClassFilenameExtension)
    }
    
    public var preferredMIMEType: String? {
        return preferredTag(kUTTagClassMIMEType)
    }
    
    public var MIMETypes: [String] {
        return allTags(kUTTagClassMIMEType)
    }
    
    #if os(OSX)
    
        public var preferredPasteboardType: String? {
            return preferredTag(kUTTagClassNSPboardType)
        }
        
        public var preferredLegacyType: OSType? {
            return preferredTag(kUTTagClassOSType).flatMap(OSType.init)
        }
    
        public var pasteboardTypes: [String] {
            return allTags(kUTTagClassNSPboardType)
        }
    
        public var preferredLegacyTypes: [OSType]? {
            return allTags(kUTTagClassOSType).flatMap(OSType.init)
        }
    
    #endif
    
}
