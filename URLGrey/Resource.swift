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
    case W1024H1024
}

// MARK Resources

public struct Resource {
    
    public static var Name:                      _Readable<NSString, String>         { return _Readable(stringValue: NSURLNameKey) }
    public static var LocalizedName:             _Readable<NSString, String>         { return _Readable(stringValue: NSURLLocalizedNameKey) }
    public static var IsRegularFile:             _Readable<NSNumber, Bool>           { return _Readable(stringValue: NSURLIsRegularFileKey) }
    public static var IsDirectory:               _Readable<NSNumber, Bool>           { return _Readable(stringValue: NSURLIsDirectoryKey) }
    public static var IsSymbolicLink:            _Readable<NSNumber, Bool>           { return _Readable(stringValue: NSURLIsSymbolicLinkKey) }
    public static var IsVolume:                  _Readable<NSNumber, Bool>           { return _Readable(stringValue: NSURLIsVolumeKey) }
    public static var IsPackage:                 _Writable<NSNumber, Bool>           { return _Writable(stringValue: NSURLIsPackageKey) }
    public static var IsSystemImmutable:         _Writable<NSNumber, Bool>           { return _Writable(stringValue: NSURLIsSystemImmutableKey) }
    public static var IsUserImmutable:           _Writable<NSNumber, Bool>           { return _Writable(stringValue: NSURLIsUserImmutableKey) }
    public static var IsHidden:                  _Writable<NSNumber, Bool>           { return _Writable(stringValue: NSURLIsHiddenKey) }
    public static var HasHiddenExtension:        _Writable<NSNumber, Bool>           { return _Writable(stringValue: NSURLHasHiddenExtensionKey) }
    public static var CreationDate:              _WritableDirect<NSDate>             { return _WritableDirect(stringValue: NSURLCreationDateKey) }
    public static var ContentAccessDate:         _ReadableDirect<NSDate>             { return _ReadableDirect(stringValue: NSURLContentAccessDateKey) }
    public static var ContentModificationDate:   _WritableDirect<NSDate>             { return _WritableDirect(stringValue: NSURLContentModificationDateKey) }
    public static var AttributeModificationDate: _WritableDirect<NSDate>             { return _WritableDirect(stringValue: NSURLAttributeModificationDateKey) }
    public static var LinkCount:                 _Readable<NSNumber, Int>            { return _Readable(stringValue: NSURLLinkCountKey) }
    public static var ParentDirectoryURL:        _ReadableDirect<NSURL>              { return _ReadableDirect(stringValue: NSURLParentDirectoryURLKey) }
    public static var VolumeURL:                 _ReadableDirect<NSURL>              { return _ReadableDirect(stringValue: NSURLVolumeURLKey) }
    public static var TypeIdentifier:            _ReadableConvert<UTI>               { return _ReadableConvert(stringValue: NSURLTypeIdentifierKey) }
    public static var LocalizedTypeDescription:  _Readable<NSString, String>         { return _Readable(stringValue: NSURLLocalizedTypeDescriptionKey) }
    public static var EffectiveIcon:             _ReadableDirect<ImageType>          { return _ReadableDirect(stringValue: NSURLEffectiveIconKey) }
    public static var CustomIcon:                _ReadableDirect<ImageType>          { return _ReadableDirect(stringValue: NSURLCustomIconKey) }
    public static var FileIdentifier:            _ReadableDirect<OpaqueType>         { return _ReadableDirect(stringValue: NSURLFileResourceIdentifierKey) }
    public static var VolumeIdentifier:          _ReadableDirect<OpaqueType>         { return _ReadableDirect(stringValue: NSURLVolumeIdentifierKey) }
    public static var PreferredIOBlockSize:      _Readable<NSNumber, Int>            { return _Readable(stringValue: NSURLPreferredIOBlockSizeKey) }
    public static var IsReadable:                _Readable<NSNumber, Bool>           { return _Readable(stringValue: NSURLIsReadableKey) }
    public static var IsWritable:                _Readable<NSNumber, Bool>           { return _Readable(stringValue: NSURLIsWritableKey) }
    public static var IsExecutable:              _Readable<NSNumber, Bool>           { return _Readable(stringValue: NSURLIsExecutableKey) }
    public static var FileSecurity:              _Writable<NSNumber, NSFileSecurity> { return _Writable(stringValue: NSURLFileSecurityKey) }
    public static var IsExcludedFromBackup:      _Writable<NSNumber, Bool>           { return _Writable(stringValue: NSURLIsExcludedFromBackupKey) }
    public static var Path:                      _Readable<NSString, String>         { return _Readable(stringValue: NSURLPathKey) }
    public static var IsMountTrigger:            _Readable<NSNumber, Bool>           { return _Readable(stringValue: NSURLIsMountTriggerKey) }
    public static var GenerationIdentifier:      _ReadableDirect<OpaqueType>         { return _ReadableDirect(stringValue: NSURLGenerationIdentifierKey) }
    public static var DocumentIdentifier:        _ReadableDirect<OpaqueType>         { return _ReadableDirect(stringValue: NSURLDocumentIdentifierKey) }
    public static var AddedToDirectoryDate:      _ReadableDirect<NSDate>             { return _ReadableDirect(stringValue: NSURLAddedToDirectoryDateKey) }
    public static var FileClass:                 _ReadableConvert<FileType>          { return _ReadableConvert(stringValue: NSURLFileResourceTypeKey) }
    
    #if os(OSX)
    public static var TagNames:                  _Writable<NSArray, [String]>        { return _Writable(stringValue: NSURLTagNamesKey) }
    public static var QuarantineAttributes:      _WritableConvert<Quarantine>        { return _WritableConvert(stringValue: NSURLQuarantinePropertiesKey) }
    public static var ThumbnailImage:            _ReadableDirect<NSImage>            { return _ReadableDirect(stringValue: NSURLThumbnailKey) }
    #endif

    public static var ThumbnailDictionary: _WritableMap<[String : ImageType], [ThumbnailSize : ImageType]> {
        return _WritableMap(stringValue: NSURLThumbnailDictionaryKey, reading: ThumbnailDictionaryRead, writing: ThumbnailDictionaryWrite)
    }

    public struct File {
        public static var Size:               _Readable<NSNumber, Int>  { return _Readable(stringValue: NSURLFileSizeKey) }
        public static var AllocatedSize:      _Readable<NSNumber, Int>  { return _Readable(stringValue: NSURLFileAllocatedSizeKey) }
        public static var TotalSize:          _Readable<NSNumber, Int>  { return _Readable(stringValue: NSURLTotalFileSizeKey) }
        public static var TotalAllocatedSize: _Readable<NSNumber, Int>  { return _Readable(stringValue: NSURLTotalFileAllocatedSizeKey) }
        public static var IsAlias:            _Readable<NSNumber, Bool> { return _Readable(stringValue: NSURLIsAliasFileKey) }
    }
    
    public struct Volume {
        public static var LocalizedFormatDescription:  _Readable<NSString, String> { return _Readable(stringValue: NSURLVolumeLocalizedFormatDescriptionKey) }
        public static var TotalCapacity:               _Readable<NSNumber, Int>    { return _Readable(stringValue: NSURLVolumeTotalCapacityKey) }
        public static var AvailableCapacity:           _Readable<NSNumber, Int>    { return _Readable(stringValue: NSURLVolumeAvailableCapacityKey) }
        public static var ResourceCount:               _Readable<NSNumber, Int>    { return _Readable(stringValue: NSURLVolumeResourceCountKey) }
        public static var SupportsPersistentIDs:       _Readable<NSNumber, Bool>   { return _Readable(stringValue: NSURLVolumeSupportsPersistentIDsKey) }
        public static var SupportsSymbolicLinks:       _Readable<NSNumber, Bool>   { return _Readable(stringValue: NSURLVolumeSupportsHardLinksKey) }
        public static var SupportsHardLinks:           _Readable<NSNumber, Bool>   { return _Readable(stringValue: NSURLVolumeSupportsJournalingKey) }
        public static var SupportsJournaling:          _Readable<NSNumber, Bool>   { return _Readable(stringValue: NSURLVolumeSupportsJournalingKey) }
        public static var IsJournaling:                _Readable<NSNumber, Bool>   { return _Readable(stringValue: NSURLVolumeIsJournalingKey) }
        public static var SupportsSparseFiles:         _Readable<NSNumber, Bool>   { return _Readable(stringValue: NSURLVolumeSupportsSparseFilesKey) }
        public static var SupportsZeroRuns:            _Readable<NSNumber, Bool>   { return _Readable(stringValue: NSURLVolumeSupportsZeroRunsKey) }
        public static var SupportsCaseSensitiveNames:  _Readable<NSNumber, Bool>   { return _Readable(stringValue: NSURLVolumeSupportsCaseSensitiveNamesKey) }
        public static var SupportsCasePreservedNames:  _Readable<NSNumber, Bool>   { return _Readable(stringValue: NSURLVolumeSupportsCasePreservedNamesKey) }
        public static var SupportsRootDirectoryDates:  _Readable<NSNumber, Bool>   { return _Readable(stringValue: NSURLVolumeSupportsRootDirectoryDatesKey) }
        public static var SupportsVolumeSizes:         _Readable<NSNumber, Bool>   { return _Readable(stringValue: NSURLVolumeSupportsVolumeSizesKey) }
        public static var SupportsRenaming:            _Readable<NSNumber, Bool>   { return _Readable(stringValue: NSURLVolumeSupportsRenamingKey) }
        public static var SupportsAdvisoryFileLocking: _Readable<NSNumber, Bool>   { return _Readable(stringValue: NSURLVolumeSupportsAdvisoryFileLockingKey) }
        public static var SupportsExtendedSecurity:    _Readable<NSNumber, Bool>   { return _Readable(stringValue: NSURLVolumeSupportsExtendedSecurityKey) }
        public static var IsBrowsable:                 _Readable<NSNumber, Bool>   { return _Readable(stringValue: NSURLVolumeIsBrowsableKey) }
        public static var MaximumFileSize:             _Readable<NSNumber, Int>    { return _Readable(stringValue: NSURLVolumeMaximumFileSizeKey) }
        public static var IsEjectable:                 _Readable<NSNumber, Bool>   { return _Readable(stringValue: NSURLVolumeIsEjectableKey) }
        public static var IsRemovable:                 _Readable<NSNumber, Bool>   { return _Readable(stringValue: NSURLVolumeIsRemovableKey) }
        public static var IsInternal:                  _Readable<NSNumber, Bool>   { return _Readable(stringValue: NSURLVolumeIsInternalKey) }
        public static var IsAutomounted:               _Readable<NSNumber, Bool>   { return _Readable(stringValue: NSURLVolumeIsAutomountedKey) }
        public static var IsLocal:                     _Readable<NSNumber, Bool>   { return _Readable(stringValue: NSURLVolumeIsLocalKey) }
        public static var IsReadOnly:                  _Readable<NSNumber, Bool>   { return _Readable(stringValue: NSURLVolumeIsReadOnlyKey) }
        public static var CreationDate:                _ReadableDirect<NSDate>     { return _ReadableDirect(stringValue: NSURLVolumeCreationDateKey) }
        public static var URLForRemounting:            _ReadableDirect<NSURL>      { return _ReadableDirect(stringValue: NSURLVolumeURLForRemountingKey) }
        public static var UUIDString:                  _Readable<NSString, String> { return _Readable(stringValue: NSURLVolumeUUIDStringKey) }
        public static var Name:                        _Writable<NSString, String> { return _Writable(stringValue: NSURLVolumeNameKey) }
        public static var LocalizedName:               _Readable<NSString, String> { return _Readable(stringValue: NSURLVolumeLocalizedNameKey) }
    }
    
    public struct UbiquitousItem {
        public static var Identity:               _Readable<NSNumber, Bool>          { return _Readable(stringValue: NSURLIsUbiquitousItemKey) }
        public static var HasUnresolvedConflicts: _Readable<NSNumber, Bool>          { return _Readable(stringValue: NSURLUbiquitousItemHasUnresolvedConflictsKey) }
        public static var IsDownloading:          _Readable<NSNumber, Bool>          { return _Readable(stringValue: NSURLUbiquitousItemIsDownloadingKey) }
        public static var IsUploaded:             _Readable<NSNumber, Bool>          { return _Readable(stringValue: NSURLUbiquitousItemIsUploadedKey) }
        public static var IsUploading:            _Readable<NSNumber, Bool>          { return _Readable(stringValue: NSURLUbiquitousItemIsUploadingKey) }
        public static var DownloadingStatus:      _ReadableConvert<UbiquitousStatus> { return _ReadableConvert(stringValue: NSURLUbiquitousItemDownloadingStatusKey) }
        public static var DownloadingError:       _ReadableDirect<NSError>           { return _ReadableDirect(stringValue: NSURLUbiquitousItemDownloadingErrorKey) }
        public static var UploadingError:         _ReadableDirect<NSError>           { return _ReadableDirect(stringValue: NSURLUbiquitousItemUploadingErrorKey) }
        public static var DownloadRequested:      _Readable<NSNumber, Bool>          { return _Readable(stringValue: NSURLUbiquitousItemDownloadRequestedKey) }
        public static var ContainerDisplayName:   _Readable<NSNumber, Bool>          { return _Readable(stringValue: NSURLUbiquitousItemContainerDisplayNameKey) }
    }
    
}
