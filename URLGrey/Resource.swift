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

public typealias ThumbnailDictionary = [ThumbnailSize:ImageType]

// MARK Resources

public struct Resource {
    
    public static var Name:                      _Readable<String>            { return _Readable(key: NSURLNameKey) }
    public static var LocalizedName:             _Readable<String>            { return _Readable(key: NSURLLocalizedNameKey) }
    public static var IsRegularFile:             _Readable<Bool>              { return _Readable(key: NSURLIsRegularFileKey) }
    public static var IsDirectory:               _Readable<Bool>              { return _Readable(key: NSURLIsDirectoryKey) }
    public static var IsSymbolicLink:            _Readable<Bool>              { return _Readable(key: NSURLIsSymbolicLinkKey) }
    public static var IsVolume:                  _Readable<Bool>              { return _Readable(key: NSURLIsVolumeKey) }
    public static var IsPackage:                 _Writable<Bool>              { return _Writable(key: NSURLIsPackageKey) }
    public static var IsSystemImmutable:         _Writable<Bool>              { return _Writable(key: NSURLIsSystemImmutableKey) }
    public static var IsUserImmutable:           _Writable<Bool>              { return _Writable(key: NSURLIsUserImmutableKey) }
    public static var IsHidden:                  _Writable<Bool>              { return _Writable(key: NSURLIsHiddenKey) }
    public static var HasHiddenExtension:        _Writable<Bool>              { return _Writable(key: NSURLHasHiddenExtensionKey) }
    public static var CreationDate:              _Writable<NSDate>            { return _Writable(key: NSURLCreationDateKey) }
    public static var ContentAccessDate:         _Readable<NSDate>            { return _Readable(key: NSURLContentAccessDateKey) }
    public static var ContentModificationDate:   _Writable<NSDate>            { return _Writable(key: NSURLContentModificationDateKey) }
    public static var AttributeModificationDate: _Writable<NSDate>            { return _Writable(key: NSURLAttributeModificationDateKey) }
    public static var LinkCount:                 _Readable<Int>               { return _Readable(key: NSURLLinkCountKey) }
    public static var ParentDirectoryURL:        _Readable<NSURL>             { return _Readable(key: NSURLParentDirectoryURLKey) }
    public static var VolumeURL:                 _Readable<NSURL>             { return _Readable(key: NSURLVolumeURLKey) }
    public static var TypeIdentifier:            _MapReadable<UTI>            { return _MapReadable(key: NSURLTypeIdentifierKey) }
    public static var LocalizedTypeDescription:  _Readable<String>            { return _Readable(key: NSURLLocalizedTypeDescriptionKey) }
    public static var EffectiveIcon:             _Readable<ImageType>         { return _Readable(key: NSURLEffectiveIconKey) }
    public static var CustomIcon:                _Readable<ImageType>         { return _Readable(key: NSURLCustomIconKey) }
    public static var FileIdentifier:            _Readable<OpaqueType>        { return _Readable(key: NSURLFileResourceIdentifierKey) }
    public static var VolumeIdentifier:          _Readable<OpaqueType>        { return _Readable(key: NSURLVolumeIdentifierKey) }
    public static var PreferredIOBlockSize:      _Readable<Int>               { return _Readable(key: NSURLPreferredIOBlockSizeKey) }
    public static var IsReadable:                _Readable<Bool>              { return _Readable(key: NSURLIsReadableKey) }
    public static var IsWritable:                _Readable<Bool>              { return _Readable(key: NSURLIsWritableKey) }
    public static var IsExecutable:              _Readable<Bool>              { return _Readable(key: NSURLIsExecutableKey) }
    public static var FileSecurity:              _Writable<NSFileSecurity>    { return _Writable(key: NSURLFileSecurityKey) }
    public static var IsExcludedFromBackup:      _Writable<Bool>              { return _Writable(key: NSURLIsExcludedFromBackupKey) }
    public static var Path:                      _Readable<String>            { return _Readable(key: NSURLPathKey) }
    public static var IsMountTrigger:            _Readable<Bool>              { return _Readable(key: NSURLIsMountTriggerKey) }
    public static var GenerationIdentifier:      _Readable<OpaqueType>        { return _Readable(key: NSURLGenerationIdentifierKey) }
    public static var DocumentIdentifier:        _Readable<OpaqueType>        { return _Readable(key: NSURLDocumentIdentifierKey) }
    public static var AddedToDirectoryDate:      _Readable<NSDate>            { return _Readable(key: NSURLAddedToDirectoryDateKey) }
    public static var FileClass:                 _MapReadable<FileType>       { return _MapReadable(key: NSURLFileResourceTypeKey) }
    public static var ThumbnailDictionary:       _WritableThumbnailDictionary { return _WritableThumbnailDictionary(key: NSURLThumbnailDictionaryKey) }
    
    #if os(OSX)
    public static var TagNames:                  _Writable<[String]>          { return _Writable(key: NSURLTagNamesKey) }
    public static var QuarantineAttributes:      _MapWritable<Quarantine>     { return _MapWritable(key: NSURLQuarantinePropertiesKey) }
    public static var ThumbnailImage:            _Readable<NSImage>           { return _Readable(key: NSURLThumbnailKey) }
    #endif
    
    public struct File {
        public static var Size:               _Readable<Int>  { return _Readable(key: NSURLFileSizeKey) }
        public static var AllocatedSize:      _Readable<Int>  { return _Readable(key: NSURLFileAllocatedSizeKey) }
        public static var TotalSize:          _Readable<Int>  { return _Readable(key: NSURLTotalFileSizeKey) }
        public static var TotalAllocatedSize: _Readable<Int>  { return _Readable(key: NSURLTotalFileAllocatedSizeKey) }
        public static var IsAlias:            _Readable<Bool> { return _Readable(key: NSURLIsAliasFileKey) }
    }
    
    public struct Volume {
        public static var LocalizedFormatDescription:  _Readable<String> { return _Readable(key: NSURLVolumeLocalizedFormatDescriptionKey) }
        public static var TotalCapacity:               _Readable<Int>    { return _Readable(key: NSURLVolumeTotalCapacityKey) }
        public static var AvailableCapacity:           _Readable<Int>    { return _Readable(key: NSURLVolumeAvailableCapacityKey) }
        public static var ResourceCount:               _Readable<Int>    { return _Readable(key: NSURLVolumeResourceCountKey) }
        public static var SupportsPersistentIDs:       _Readable<Bool>   { return _Readable(key: NSURLVolumeSupportsPersistentIDsKey) }
        public static var SupportsSymbolicLinks:       _Readable<Bool>   { return _Readable(key: NSURLVolumeSupportsHardLinksKey) }
        public static var SupportsHardLinks:           _Readable<Bool>   { return _Readable(key: NSURLVolumeSupportsJournalingKey) }
        public static var SupportsJournaling:          _Readable<Bool>   { return _Readable(key: NSURLVolumeSupportsJournalingKey) }
        public static var IsJournaling:                _Readable<Bool>   { return _Readable(key: NSURLVolumeIsJournalingKey) }
        public static var SupportsSparseFiles:         _Readable<Bool>   { return _Readable(key: NSURLVolumeSupportsSparseFilesKey) }
        public static var SupportsZeroRuns:            _Readable<Bool>   { return _Readable(key: NSURLVolumeSupportsZeroRunsKey) }
        public static var SupportsCaseSensitiveNames:  _Readable<Bool>   { return _Readable(key: NSURLVolumeSupportsCaseSensitiveNamesKey) }
        public static var SupportsCasePreservedNames:  _Readable<Bool>   { return _Readable(key: NSURLVolumeSupportsCasePreservedNamesKey) }
        public static var SupportsRootDirectoryDates:  _Readable<Bool>   { return _Readable(key: NSURLVolumeSupportsRootDirectoryDatesKey) }
        public static var SupportsVolumeSizes:         _Readable<Bool>   { return _Readable(key: NSURLVolumeSupportsVolumeSizesKey) }
        public static var SupportsRenaming:            _Readable<Bool>   { return _Readable(key: NSURLVolumeSupportsRenamingKey) }
        public static var SupportsAdvisoryFileLocking: _Readable<Bool>   { return _Readable(key: NSURLVolumeSupportsAdvisoryFileLockingKey) }
        public static var SupportsExtendedSecurity:    _Readable<Bool>   { return _Readable(key: NSURLVolumeSupportsExtendedSecurityKey) }
        public static var IsBrowsable:                 _Readable<Bool>   { return _Readable(key: NSURLVolumeIsBrowsableKey) }
        public static var MaximumFileSize:             _Readable<Int>    { return _Readable(key: NSURLVolumeMaximumFileSizeKey) }
        public static var IsEjectable:                 _Readable<Bool>   { return _Readable(key: NSURLVolumeIsEjectableKey) }
        public static var IsRemovable:                 _Readable<Bool>   { return _Readable(key: NSURLVolumeIsRemovableKey) }
        public static var IsInternal:                  _Readable<Bool>   { return _Readable(key: NSURLVolumeIsInternalKey) }
        public static var IsAutomounted:               _Readable<Bool>   { return _Readable(key: NSURLVolumeIsAutomountedKey) }
        public static var IsLocal:                     _Readable<Bool>   { return _Readable(key: NSURLVolumeIsLocalKey) }
        public static var IsReadOnly:                  _Readable<Bool>   { return _Readable(key: NSURLVolumeIsReadOnlyKey) }
        public static var CreationDate:                _Readable<NSDate> { return _Readable(key: NSURLVolumeCreationDateKey) }
        public static var URLForRemounting:            _Readable<NSURL>  { return _Readable(key: NSURLVolumeURLForRemountingKey) }
        public static var UUIDString:                  _Readable<String> { return _Readable(key: NSURLVolumeUUIDStringKey) }
        public static var Name:                        _Writable<String> { return _Writable(key: NSURLVolumeNameKey) }
        public static var LocalizedName:               _Readable<String> { return _Readable(key: NSURLVolumeLocalizedNameKey) }
    }
    
    public struct UbiquitousItem {
        public static var Identity:               _Readable<Bool>                { return _Readable(key: NSURLIsUbiquitousItemKey) }
        public static var HasUnresolvedConflicts: _Readable<Bool>                { return _Readable(key: NSURLUbiquitousItemHasUnresolvedConflictsKey) }
        public static var IsDownloading:          _Readable<Bool>                { return _Readable(key: NSURLUbiquitousItemIsDownloadingKey) }
        public static var IsUploaded:             _Readable<Bool>                { return _Readable(key: NSURLUbiquitousItemIsUploadedKey) }
        public static var IsUploading:            _Readable<Bool>                { return _Readable(key: NSURLUbiquitousItemIsUploadingKey) }
        public static var DownloadingStatus:      _MapReadable<UbiquitousStatus> { return _MapReadable(key: NSURLUbiquitousItemDownloadingStatusKey) }
        public static var DownloadingError:       _Readable<NSError>             { return _Readable(key: NSURLUbiquitousItemDownloadingErrorKey) }
        public static var UploadingError:         _Readable<NSError>             { return _Readable(key: NSURLUbiquitousItemUploadingErrorKey) }
        public static var DownloadRequested:      _Readable<Bool>                { return _Readable(key: NSURLUbiquitousItemDownloadRequestedKey) }
        public static var ContainerDisplayName:   _Readable<Bool>                { return _Readable(key: NSURLUbiquitousItemContainerDisplayNameKey) }
    }
    
}
