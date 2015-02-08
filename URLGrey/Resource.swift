//
//  Resource.swift
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

public typealias OpaqueType = protocol<NSObjectProtocol, NSCopying, NSCoding>

// MARK: File Resource Type

public enum FileType {
    case NamedPipe
    case CharacterSpecial
    case Directory
    case BlockSpecial
    case Regular
    case SymbolicLink
    case Socket
    case Unknown
}

// MARK: Quarantine Attributes

#if os(OSX)
    
    public struct Quarantine {
        
        public enum Kind {
            case Unknown
            case WebDownload
            case OtherDownload
            case EmailAttachment
            case InstantMessageAttachment
            case CalendarEventAttachment
            case OtherAttachment
        }
        
        var agentName: String?
        var agentBundleIdentifier: String?
        var timestamp: NSDate?
        var kind: Kind
        var dataURL: NSURL?
        var originURL: NSURL?
        
    }
    
#endif

// MARK: Ubiquitous Item Status

public enum UbiquitousStatus {
    case NotDownloaded
    case Downloaded
    case Current
}

// MARK: Image Thumbnail Dictionary

#if os(OSX)
    public typealias ImageType = NSImage
#elseif os(iOS)
    public typealias ImageType = UIImage
#endif

public enum ThumbnailSize {
    case W1024
}

// MARK Resources

public struct Resource {
    
    public static var Name:                      _Readable<String>               { return _Readable(key: NSURLNameKey) }
    public static var LocalizedName:             _Readable<String>               { return _Readable(key: NSURLLocalizedNameKey) }
    public static var IsRegularFile:             _Readable<Bool>                 { return _Readable(key: NSURLIsRegularFileKey) }
    public static var IsDirectory:               _Readable<Bool>                 { return _Readable(key: NSURLIsDirectoryKey) }
    public static var IsSymbolicLink:            _Readable<Bool>                 { return _Readable(key: NSURLIsSymbolicLinkKey) }
    public static var IsVolume:                  _Readable<Bool>                 { return _Readable(key: NSURLIsVolumeKey) }
    public static var IsPackage:                 _Readable<Bool>                 { return _Readable(key: NSURLIsPackageKey) }
    public static var IsSystemImmutable:         _Readable<Bool>                 { return _Readable(key: NSURLIsSystemImmutableKey) }
    public static var IsUserImmutable:           _Readable<Bool>                 { return _Readable(key: NSURLIsUserImmutableKey) }
    public static var IsHidden:                  _Readable<Bool>                 { return _Readable(key: NSURLIsHiddenKey) }
    public static var HasHiddenExtension:        _Readable<Bool>                 { return _Readable(key: NSURLHasHiddenExtensionKey) }
    public static var CreationDate:              _WritableObject<NSDate>         { return _WritableObject(key: NSURLCreationDateKey) }
    public static var ContentAccessDate:         _ReadableObject<NSDate>         { return _ReadableObject(key: NSURLContentAccessDateKey) }
    public static var ContentModificationDate:   _WritableObject<NSDate>         { return _WritableObject(key: NSURLContentModificationDateKey) }
    public static var AttributeModificationDate: _WritableObject<NSDate>         { return _WritableObject(key: NSURLAttributeModificationDateKey) }
    public static var LinkCount:                 _Readable<Int>                  { return _Readable(key: NSURLLinkCountKey) }
    public static var ParentDirectoryURL:        _ReadableObject<NSURL>          { return _ReadableObject(key: NSURLParentDirectoryURLKey) }
    public static var VolumeURL:                 _ReadableObject<NSURL>          { return _ReadableObject(key: NSURLVolumeURLKey) }
    public static var TypeIdentifier:            _ReadableConvert<UTI>           { return _ReadableConvert(key: NSURLTypeIdentifierKey) }
    public static var LocalizedTypeDescription:  _Readable<String>               { return _Readable(key: NSURLLocalizedTypeDescriptionKey) }
    public static var EffectiveIcon:             _ReadableObject<ImageType>      { return _ReadableObject(key: NSURLEffectiveIconKey) }
    public static var CustomIcon:                _ReadableObject<ImageType>      { return _ReadableObject(key: NSURLCustomIconKey) }
    public static var FileIdentifier:            _ReadableObject<OpaqueType>     { return _ReadableObject(key: NSURLFileResourceIdentifierKey) }
    public static var VolumeIdentifier:          _ReadableObject<OpaqueType>     { return _ReadableObject(key: NSURLVolumeIdentifierKey) }
    public static var PreferredIOBlockSize:      _Readable<Int>                  { return _Readable(key: NSURLPreferredIOBlockSizeKey) }
    public static var IsReadable:                _Readable<Bool>                 { return _Readable(key: NSURLIsReadableKey) }
    public static var IsWritable:                _Readable<Bool>                 { return _Readable(key: NSURLIsWritableKey) }
    public static var IsExecutable:              _Readable<Bool>                 { return _Readable(key: NSURLIsExecutableKey) }
    public static var FileSecurity:              _WritableObject<NSFileSecurity> { return _WritableObject(key: NSURLFileSecurityKey) }
    public static var IsExcludedFromBackup:      _Writable<Bool, NSNumber>       { return _Writable(key: NSURLIsExcludedFromBackupKey) }
    public static var Path:                      _Readable<String>               { return _Readable(key: NSURLPathKey) }
    public static var IsMountTrigger:            _Readable<Bool>                 { return _Readable(key: NSURLIsMountTriggerKey) }
    public static var GenerationIdentifier:      _ReadableObject<OpaqueType>     { return _ReadableObject(key: NSURLGenerationIdentifierKey) }
    public static var DocumentIdentifier:        _ReadableObject<OpaqueType>     { return _ReadableObject(key: NSURLDocumentIdentifierKey) }
    public static var AddedToDirectoryDate:      _ReadableObject<NSDate>         { return _ReadableObject(key: NSURLAddedToDirectoryDateKey) }
    public static var FileClass:                 _ReadableConvert<FileType>      { return _ReadableConvert(key: NSURLFileResourceTypeKey) }
    
    #if os(OSX)
    public static var TagNames:                  _Writable<[String], NSArray> { return _Writable(key: NSURLTagNamesKey) }
    public static var QuarantineAttributes:      _WritableConvert<Quarantine> { return _WritableConvert(key: NSURLQuarantinePropertiesKey) }
    public static var ThumbnailImage:            _ReadableObject<NSImage>     { return _ReadableObject(key: NSURLThumbnailKey) }
    #endif

    public static var ThumbnailDictionary: _WritableOf<[ThumbnailSize: ImageType], [String: ImageType]> {
        return _WritableOf(key: NSURLThumbnailDictionaryKey, reading: ThumbnailDictionaryRead, writing: ThumbnailDictionaryWrite)
    }

    public struct File {
        public static var Size:               _Readable<Int>  { return _Readable(key: NSURLFileSizeKey) }
        public static var AllocatedSize:      _Readable<Int>  { return _Readable(key: NSURLFileAllocatedSizeKey) }
        public static var TotalSize:          _Readable<Int>  { return _Readable(key: NSURLTotalFileSizeKey) }
        public static var TotalAllocatedSize: _Readable<Int>  { return _Readable(key: NSURLTotalFileAllocatedSizeKey) }
        public static var IsAlias:            _Readable<Bool> { return _Readable(key: NSURLIsAliasFileKey) }
    }
    
    public struct Volume {
        public static var LocalizedFormatDescription:  _Readable<String>           { return _Readable(key: NSURLVolumeLocalizedFormatDescriptionKey) }
        public static var TotalCapacity:               _Readable<Int>              { return _Readable(key: NSURLVolumeTotalCapacityKey) }
        public static var AvailableCapacity:           _Readable<Int>              { return _Readable(key: NSURLVolumeAvailableCapacityKey) }
        public static var ResourceCount:               _Readable<Int>              { return _Readable(key: NSURLVolumeResourceCountKey) }
        public static var SupportsPersistentIDs:       _Readable<Bool>             { return _Readable(key: NSURLVolumeSupportsPersistentIDsKey) }
        public static var SupportsSymbolicLinks:       _Readable<Bool>             { return _Readable(key: NSURLVolumeSupportsHardLinksKey) }
        public static var SupportsHardLinks:           _Readable<Bool>             { return _Readable(key: NSURLVolumeSupportsJournalingKey) }
        public static var SupportsJournaling:          _Readable<Bool>             { return _Readable(key: NSURLVolumeSupportsJournalingKey) }
        public static var IsJournaling:                _Readable<Bool>             { return _Readable(key: NSURLVolumeIsJournalingKey) }
        public static var SupportsSparseFiles:         _Readable<Bool>             { return _Readable(key: NSURLVolumeSupportsSparseFilesKey) }
        public static var SupportsZeroRuns:            _Readable<Bool>             { return _Readable(key: NSURLVolumeSupportsZeroRunsKey) }
        public static var SupportsCaseSensitiveNames:  _Readable<Bool>             { return _Readable(key: NSURLVolumeSupportsCaseSensitiveNamesKey) }
        public static var SupportsCasePreservedNames:  _Readable<Bool>             { return _Readable(key: NSURLVolumeSupportsCasePreservedNamesKey) }
        public static var SupportsRootDirectoryDates:  _Readable<Bool>             { return _Readable(key: NSURLVolumeSupportsRootDirectoryDatesKey) }
        public static var SupportsVolumeSizes:         _Readable<Bool>             { return _Readable(key: NSURLVolumeSupportsVolumeSizesKey) }
        public static var SupportsRenaming:            _Readable<Bool>             { return _Readable(key: NSURLVolumeSupportsRenamingKey) }
        public static var SupportsAdvisoryFileLocking: _Readable<Bool>             { return _Readable(key: NSURLVolumeSupportsAdvisoryFileLockingKey) }
        public static var SupportsExtendedSecurity:    _Readable<Bool>             { return _Readable(key: NSURLVolumeSupportsExtendedSecurityKey) }
        public static var IsBrowsable:                 _Readable<Bool>             { return _Readable(key: NSURLVolumeIsBrowsableKey) }
        public static var MaximumFileSize:             _Readable<Int>              { return _Readable(key: NSURLVolumeMaximumFileSizeKey) }
        public static var IsEjectable:                 _Readable<Bool>             { return _Readable(key: NSURLVolumeIsEjectableKey) }
        public static var IsRemovable:                 _Readable<Bool>             { return _Readable(key: NSURLVolumeIsRemovableKey) }
        public static var IsInternal:                  _Readable<Bool>             { return _Readable(key: NSURLVolumeIsInternalKey) }
        public static var IsAutomounted:               _Readable<Bool>             { return _Readable(key: NSURLVolumeIsAutomountedKey) }
        public static var IsLocal:                     _Readable<Bool>             { return _Readable(key: NSURLVolumeIsLocalKey) }
        public static var IsReadOnly:                  _Readable<Bool>             { return _Readable(key: NSURLVolumeIsReadOnlyKey) }
        public static var CreationDate:                _ReadableObject<NSDate>     { return _ReadableObject(key: NSURLVolumeCreationDateKey) }
        public static var URLForRemounting:            _ReadableObject<NSURL>      { return _ReadableObject(key: NSURLVolumeURLForRemountingKey) }
        public static var UUIDString:                  _Readable<String>           { return _Readable(key: NSURLVolumeUUIDStringKey) }
        public static var Name:                        _Writable<String, NSString> { return _Writable(key: NSURLVolumeNameKey) }
        public static var LocalizedName:               _Readable<String>           { return _Readable(key: NSURLVolumeLocalizedNameKey) }
    }
    
    public struct UbiquitousItem {
        public static var Identity:               _Readable<Bool>                    { return _Readable(key: NSURLIsUbiquitousItemKey) }
        public static var HasUnresolvedConflicts: _Readable<Bool>                    { return _Readable(key: NSURLUbiquitousItemHasUnresolvedConflictsKey) }
        public static var IsDownloading:          _Readable<Bool>                    { return _Readable(key: NSURLUbiquitousItemIsDownloadingKey) }
        public static var IsUploaded:             _Readable<Bool>                    { return _Readable(key: NSURLUbiquitousItemIsUploadedKey) }
        public static var IsUploading:            _Readable<Bool>                    { return _Readable(key: NSURLUbiquitousItemIsUploadingKey) }
        public static var DownloadingStatus:      _ReadableConvert<UbiquitousStatus> { return _ReadableConvert(key: NSURLUbiquitousItemDownloadingStatusKey) }
        public static var DownloadingError:       _ReadableObject<NSError>           { return _ReadableObject(key: NSURLUbiquitousItemDownloadingErrorKey) }
        public static var UploadingError:         _ReadableObject<NSError>           { return _ReadableObject(key: NSURLUbiquitousItemUploadingErrorKey) }
        public static var DownloadRequested:      _Readable<Bool>                    { return _Readable(key: NSURLUbiquitousItemDownloadRequestedKey) }
        public static var ContainerDisplayName:   _Readable<Bool>                    { return _Readable(key: NSURLUbiquitousItemContainerDisplayNameKey) }
    }
    
}
