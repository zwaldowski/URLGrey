//
//  Resource.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 10/21/14.
//  Copyright (c) 2014 Zachary Waldowski. All rights reserved.
//

import Foundation
import Lustre

#if os(OSX)
import AppKit.NSImage
#endif

// MARK: URL Resource Prototypes

/// A static namespace providing prototypes for resources that may be fetched
/// from URLs.
public extension ReadableResource {
    
    // MARK: Item resources
    
    /// The resource name provided by the file system.
    static var Name: ReadableResource<AnyResult<String>> {
        return readable(NSURLNameKey)
    }
    
    /// Localized or extension-hidden name as displayed to users.
    static var LocalizedName: ReadableResource<AnyResult<String>> {
        return readable(NSURLLocalizedNameKey)
    }
    
    /// True for regular files.
    static var IsRegularFile: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLIsRegularFileKey)
    }
    
    /// True for directories.
    static var IsDirectory: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLIsDirectoryKey)
    }
    
    /// True for symlinks.
    static var IsSymbolicLink: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLIsSymbolicLinkKey)
    }
    
    /// Whether the URL represents the root directory of a volume.
    static var IsVolume: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLIsVolumeKey)
    }
    
    /// Whether the URL represents a directory that appears as a file unit.
    static var IsPackage: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLIsPackageKey)
    }
    
    /// Whether the item cannot be written to by the system.
    static var IsSystemImmutable: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLIsSystemImmutableKey)
    }
    
    /// Whether the item cannot be written to by the user.
    static var IsUserImmutable: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLIsUserImmutableKey)
    }
    
    /// Whether the item is normally not displayed to users.
    static var IsHidden: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLIsHiddenKey)
    }
    
    /// Whether the filename extension is removed from the localized name.
    static var HasHiddenExtension: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLHasHiddenExtensionKey)
    }
    
    /// The date the item was created.
    static var CreationDate: ReadableResource<ObjectResult<NSDate>> {
        return readableObject(NSURLCreationDateKey)
    }
    
    /// The date the item was last accessed.
    static var ContentAccessDate: ReadableResource<ObjectResult<NSDate>> {
        return readableObject(NSURLContentAccessDateKey)
    }
    
    /// The time the item's content was last modified.
    static var ContentModificationDate: ReadableResource<ObjectResult<NSDate>> {
        return readableObject(NSURLContentModificationDateKey)
    }
    
    /// The time the item's attributes were last modified.
    static var AttributeModificationDate: ReadableResource<ObjectResult<NSDate>> {
        return readableObject(NSURLAttributeModificationDateKey)
    }
    
    /// Number of hard links to the item.
    static var LinkCount: ReadableResource<AnyResult<Int>> {
        return readable(NSURLLinkCountKey)
    }
    
    /// The item's parent directory, if any.
    static var ParentDirectoryURL: ReadableResource<ObjectResult<NSURL>> {
        return readableObject(NSURLParentDirectoryURLKey)
    }
    
    /// URL of the volume on which the item is stored.
    static var VolumeURL: ReadableResource<ObjectResult<NSURL>> {
        return readableObject(NSURLVolumeURLKey)
    }
    
    /// Uniform type identifier (UTI) for the resource.
    static var TypeIdentifier: ReadableResource<AnyResult<UTI>> {
        return readableConvert(NSURLTypeIdentifierKey)
    }
    
    /// User-visible type or "kind" description.
    static var LocalizedTypeDescription: ReadableResource<AnyResult<String>> {
        return readable(NSURLLocalizedTypeDescriptionKey)
    }
    
    /// The icon normally displayed for the resource.
    static var EffectiveIcon: ReadableResource<ObjectResult<ImageType>> {
        return readableObject(NSURLEffectiveIconKey)
    }
    
    /// The custom icon assigned to the resource, if any.
    ///
    /// :warning: Currently not implemented in Foundation.
    @availability(*, unavailable)
    static var CustomIcon: ReadableResource<ObjectResult<ImageType>> {
        return readableObject(NSURLCustomIconKey)
    }
    
    static var FileIdentifier: ReadableResource<ObjectResult<OpaqueType>> {
        return readableObject(NSURLFileResourceIdentifierKey)
    }
    
    /// An identifier that can be used to identify the volume the file system
    /// object is on.
    ///
    /// Other objects on the same volume will have the same volume identifier
    /// and can be compared for equality.
    ///
    /// :note: This identifier is not persistent across system restarts.
    static var VolumeIdentifier: ReadableResource<ObjectResult<OpaqueType>> {
        return readableObject(NSURLVolumeIdentifierKey)
    }
    
    /// The optimal block size when reading or writing this file's data.
    static var PreferredIOBlockSize: ReadableResource<AnyResult<Int>> {
        return readable(NSURLPreferredIOBlockSizeKey)
    }
    
    /// Whether this process (as determined by EUID) can read from the URL.
    static var IsReadable: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLIsReadableKey)
    }
    
    /// Whether this process (as determined by EUID) can write to the URL.
    static var IsWritable: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLIsWritableKey)
    }
    
    /// Whether this process (as determined by EUID) can execute a file at a
    /// URL or search a directory at a URL.
    static var IsExecutable: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLIsExecutableKey)
    }
    
    /// The file system object's security information.
    static var FileSecurity: ReadableResource<ObjectResult<NSFileSecurity>> {
        return readableObject(NSURLFileSecurityKey)
    }
    
    /// Whether resource should be excluded from backups.
    static var IsExcludedFromBackup: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLIsExcludedFromBackupKey)
    }
    
    /// The URL's path as a file system path.
    static var Path: ReadableResource<AnyResult<String>> {
        return readable(NSURLPathKey)
    }
    
    /// Whether this URL is a file system trigger directory.
    ///
    /// Traversing or opening a file system trigger will cause an attempt to
    /// mount a file system on the trigger directory.
    ///
    /// :availability: Mac OS X 10.10 and iOS 8.0
    static var IsMountTrigger: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLIsMountTriggerKey)
    }
    
    /// An opaque generation identifier which can be compared to determine if
    /// the data in a document has been modified.
    ///
    /// For URLs which refer to the same file inode, this value will change when
    /// the data in the file's data fork is changed. Changes to extended
    /// attributes or other metadata do not change the generation identifier.
    ///
    /// For URLs which refer to the same directory inode, the generation
    /// identifier will change when direct children of that directory are added,
    /// removed or renamed. Changes to the data of the direct children of that
    /// directory will not change the generation identifier.
    ///
    /// The generation identifier is persistent across system restarts.
    /// The generation identifier is tied to a specific document on a specific
    /// volume and is not transferred when copied to another volume.
    ///
    /// :note: This resource is not supported by all volumes.
    /// :availability: Mac OS X 10.10 and iOS 8.0
    static var GenerationIdentifier: ReadableResource<ObjectResult<OpaqueType>> {
        return readableObject(NSURLGenerationIdentifierKey)
    }
    
    /// A value assigned by the kernel to a document, which can be either a file
    /// or directory) and is used to identify the document regardless of where
    /// it gets moved on a volume.
    ///
    /// The document identifier survives "safe save" operations, such as file
    /// replacement methods on `NSFileManager`; i.e. it is sticky to the path it
    /// was assigned to. The document identifier is persistent across system
    /// restarts. The document identifier is not transferred when the file is
    /// copied. Document identifiers are only unique within a single volume.
    ///
    /// :note: This resource is not supported by all volumes.
    /// :availability: Mac OS X 10.10 and iOS 8.0
    static var DocumentIdentifier: ReadableResource<ObjectResult<OpaqueType>> {
        return readableObject(NSURLDocumentIdentifierKey)
    }
    
    /// The date the resource was created, renamed into, or renamed within its
    /// parent directory.
    ///
    /// Inconsistent behavior may be observed when this attribute is
    /// requested on hard-linked items.
    ///
    /// :note: This resource is not supported by all volumes.
    /// :availability: Mac OS X 10.10 and iOS 8.0
    static var AddedToDirectoryDate: ReadableResource<ObjectResult<NSDate>> {
        return readableObject(NSURLAddedToDirectoryDateKey)
    }
    
    /// The file system object type.
    ///
    /// :see: FileType
    static var FileClass: ReadableResource<AnyResult<FileType>> {
        return readableConvert(NSURLFileResourceTypeKey)
    }
    
    #if os(OSX)
    
    /// The array of Tag names.
    static var TagNames: ReadableResource<AnyResult<[String]>> {
        return readable( NSURLTagNamesKey)
    }
    
    // The quarantine properties as defined in `LaunchServices.LSQuarantine`.
    // To remove quarantine information from a file, pass NSNull as the value when setting this property. (Read-write, value type NSDictionary)
    static var QuarantineAttributes: ReadableResource<AnyResult<Quarantine>> {
        return readableConvert(NSURLQuarantinePropertiesKey)
    }
    
    /// All thumbnails as a single multi-representation `NSImage`.
    ///
    /// :availability: Mac OS X 10.10
    static var ThumbnailImage: ReadableResource<ObjectResult<NSImage>> {
        return readableObject(NSURLThumbnailKey)
    }
    
    #endif
    
    /// Dictionary of `NSImage` or `UIImage` objects keyed by size.
    ///
    /// :availability: Mac OS X 10.10 and iOS 8.0
    public static var Thumbnails: ReadableResource<AnyResult<[ThumbnailSize: ImageType]>> {
        return readableOf(NSURLThumbnailDictionaryKey, reader: ThumbnailSize.readDictionary)
    }
    
    // MARK: File resources
    
    /// Total file size in bytes.
    static var FileSize: ReadableResource<AnyResult<Int>> {
        return readable(NSURLFileSizeKey)
    }
    
    /// Total size allocated on disk for the file in bytes.
    ///
    /// This value is equivalent to number of blocks times block size.
    static var FileAllocatedSize: ReadableResource<AnyResult<Int>> {
        return readable(NSURLFileAllocatedSizeKey)
    }
    
    /// Total displayable size of the file in bytes.
    ///
    /// This may include space used by metadata.
    static var TotalFileSize: ReadableResource<AnyResult<Int>> {
        return readable(NSURLTotalFileSizeKey)
    }
    
    /// Total allocated size of the file in bytes.
    ///
    /// This value may include space used by metadata. It maybe can be
    /// less than the total file size if the resource is compressed.
    static var TotalFileAllocatedSize: ReadableResource<AnyResult<Int>> {
        return readable(NSURLTotalFileAllocatedSizeKey)
    }
    
    /// Whether the resource is a Finder alias file or a symbolic link.
    static var FileIsAlias: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLIsAliasFileKey)
    }
    
    // MARK: Volume resources
    
    /// The user-visible localized volume format.
    static var VolumeLocalizedFormatDescription: ReadableResource<AnyResult<String>> {
        return readable(NSURLVolumeLocalizedFormatDescriptionKey)
    }
    
    /// Total volume capacity in bytes.
    static var VolumeTotalCapacity: ReadableResource<AnyResult<Int>> {
        return readable(NSURLVolumeTotalCapacityKey)
    }
    
    /// Total volume free space in bytes.
    static var VolumeAvailableCapacity: ReadableResource<AnyResult<Int>> {
        return readable(NSURLVolumeAvailableCapacityKey)
    }
    
    /// Total number of resources on the volume.
    static var VolumeResourceCount: ReadableResource<AnyResult<Int>> {
        return readable(NSURLVolumeResourceCountKey)
    }
    
    /// Whether the volume format supports persistent object identifiers
    /// and can look up file system objects by their IDs.
    static var VolumeSupportsPersistentIDs: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLVolumeSupportsPersistentIDsKey)
    }
    
    /// Whether the volume format supports symbolic links.
    static var VolumeSupportsSymbolicLinks: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLVolumeSupportsHardLinksKey)
    }
    
    /// Whether the volume format supports hard links.
    static var VolumeSupportsHardLinks: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLVolumeSupportsJournalingKey)
    }
    
    /// Whether the volume format supports a journal used to speed recovery
    /// in case of unplanned restart (such as a power outage or crash). This
    /// does not necessarily mean the volume is actively using a journal.
    ///
    /// :see: VolumeIsJournaling
    static var VolumeSupportsJournaling: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLVolumeSupportsJournalingKey)
    }
    
    /// Whether the volume is currently using a journal for speedy recovery
    /// after an unplanned restart.
    static var VolumeIsJournaling: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLVolumeIsJournalingKey)
    }
    
    /// Whether the volume format supports sparse files.
    ///
    /// Sparse files can have 'holes' that have never been written to, and
    /// thus do not consume space on disk. A sparse file may have an
    /// allocated size on disk that is less than its logical length.
    static var VolumeSupportsSparseFiles: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLVolumeSupportsSparseFilesKey)
    }
    
    /// Whether the volume keeps track of allocated but unwritten runs of a
    /// file so that it can substitute zeroes without actually writing
    /// zeroes to the media.
    ///
    /// For security reasons, parts of a file (runs) that have never been
    /// written to must appear to contain zeroes.
    static var VolumeSupportsZeroRuns: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLVolumeSupportsZeroRunsKey)
    }
    
    /// Whether the volume format treats upper and lower case characters in
    /// file and directory names as different.
    ///
    /// If the volume is not case-aware, an upper case character is
    /// equivalent to a lower case character, and you can't have two names
    /// that differ solely in the case of the characters.
    static var SupportsCaseSensitiveNames: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLVolumeSupportsCaseSensitiveNamesKey)
    }
    
    /// Whether the volume format preserves the case of file and directory
    /// names.
    ///
    /// If the volume does not preserve case, it may change the case of some
    /// characters (typically making them all upper or all lower case).
    static var VolumeSupportsCasePreservedNames: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLVolumeSupportsCasePreservedNamesKey)
    }
    
    /// Whether the volume supports reliable storage of times for the root
    /// directory.
    static var VolumeSupportsRootDirectoryDates: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLVolumeSupportsRootDirectoryDatesKey)
    }
    
    /// Whether the volume supports returning volume size values.
    ///
    /// :see: VolumeTotalCapacity
    /// :see: VolumeAvailableCapacity
    static var VolumeSupportsVolumeSizes: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLVolumeSupportsVolumeSizesKey)
    }
    
    /// Whether the volume can be renamed.
    static var VolumeSupportsRenaming: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLVolumeSupportsRenamingKey)
    }
    /// Whether the volume implements whole-file `flock(2)`-style advisory
    /// locks, and the `O_EXLOCK` and `O_SHLOCK` flags of the `open(2)`
    /// call.
    static var VolumeSupportsAdvisoryFileLocking: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLVolumeSupportsAdvisoryFileLockingKey)
    }
    /// Whether the volume implements extended security (ACLs).
    static var VolumeSupportsExtendedSecurity: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLVolumeSupportsExtendedSecurityKey)
    }
    /// Whether the volume should be visible via the GUI, such as on the
    /// Desktop in the Finder.
    static var VolumeIsBrowsable: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLVolumeIsBrowsableKey)
    }
    
    /// The largest file size (in bytes) supported by this file system.
    static var VolumeMaximumFileSize: ReadableResource<AnyResult<Int>> {
        return readable(NSURLVolumeMaximumFileSizeKey)
    }
    
    /// Whether the volume's media is ejectable from the drive mechanism
    /// under software control.
    static var VolumeIsEjectable: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLVolumeIsEjectableKey)
    }
    
    /// Whether the volume's media is removable from the drive mechanism.
    static var VolumeIsRemovable: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLVolumeIsRemovableKey)
    }
    
    /// Whether the volume's device is connected to an internal bus.
    static var VolumeIsInternal: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLVolumeIsInternalKey)
    }
    
    /// Whether the volume is automounted.
    ///
    /// :note: Not to be mistaken for the volume being browsable; the
    ///        volume may be mounted but not visible to the user.
    /// :see: VolumeIsBrowsable
    static var VolumeIsAutomounted: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLVolumeIsAutomountedKey)
    }
    
    /// Whether the volume is stored on a local device.
    static var VolumeIsLocal: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLVolumeIsLocalKey)
    }
    
    /// Whether the volume is read-only.
    static var VolumeIsReadOnly: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLVolumeIsReadOnlyKey)
    }
    
    /// The volume's creation date.
    static var VolumeCreationDate: ReadableResource<ObjectResult<NSDate>> {
        return readableObject(NSURLVolumeCreationDateKey)
    }
    
    /// The URL needed to remount a network volume.
    static var VolumeURLForRemounting: ReadableResource<ObjectResult<NSURL>> {
        return readableObject(NSURLVolumeURLForRemountingKey)
    }
    
    /// The volume's persistent UUID.
    static var VolumeUUID: ReadableResource<AnyResult<String>> {
        return readable(NSURLVolumeUUIDStringKey)
    }
    
    /// The name of the volume.
    ///
    /// Though this resource is writable, if the volume does not support
    /// renaming, writes will always fail.
    ///
    /// :see: VolumeSupportsRenaming
    static var VolumeName: ReadableResource<AnyResult<String>> {
        return readable(NSURLVolumeNameKey)
    }
    
    /// The user-friendly presentable name of the volume.
    static var VolumeLocalizedName: ReadableResource<AnyResult<String>> {
        return readable(NSURLVolumeLocalizedNameKey)
    }
    
    // MARK: Ubiquitous item resources
    
    /// Whether this item is synced to the cloud or is only a local file.
    static var IsUbiquitous: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLIsUbiquitousItemKey)
    }
    
    /// Whether this item has conflicts outstanding.
    static var UbiquityHasUnresolvedConflicts: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLUbiquitousItemHasUnresolvedConflictsKey)
    }
    
    /// Whether data is being downloaded for this item.
    static var UbiquityIsDownloading: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLUbiquitousItemIsDownloadingKey)
    }
    
    /// Whether there is data present in the cloud for this item.
    static var UbiquityIsUploaded: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLUbiquitousItemIsUploadedKey)
    }
    
    /// Whether data is being uploaded for this item.
    static var UbiquityIsUploading: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLUbiquitousItemIsUploadingKey)
    }
    /// The download status of this item.
    static var UbiquityDownloadingStatus: ReadableResource<AnyResult<UbiquitousStatus>> {
        return readableConvert(NSURLUbiquitousItemDownloadingStatusKey)
    }
    
    /// The error when downloading the item from iCloud failed.
    ///
    /// See the `NSUbiquitousFile` section in `Foundation.FoundationErrors`.
    static var UbiquityDownloadingError: ReadableResource<ObjectResult<NSError>> {
        return readableObject(NSURLUbiquitousItemDownloadingErrorKey)
    }
    
    /// The error when uploading the item to iCloud failed.
    ///
    /// See the `NSUbiquitousFile` section in `Foundation.FoundationErrors`.
    static var UbiquityUploadingError: ReadableResource<ObjectResult<NSError>> {
        return readableObject(NSURLUbiquitousItemUploadingErrorKey)
    }
    
    /// Whether a download of this item has already been requested with an
    /// API like `-startDownloadingUbiquitousItemAtURL:error:.`
    ///
    /// :availability: Mac OS X 10.10 and iOS 8.0
    static var UbiquityDownloadRequested: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLUbiquitousItemDownloadRequestedKey)
    }
    
    /// The name of this item's container as displayed to users.
    ///
    /// :availability: Mac OS X 10.10 and iOS 8.0
    static var UbiquityContainerDisplayName: ReadableResource<AnyResult<Bool>> {
        return readable(NSURLUbiquitousItemContainerDisplayNameKey)
    }
    
}

// MARK: URL Resource Prototypes

/// A static namespace providing prototypes for resources that may be fetched
/// from URLs.
public extension WritableResource {
    
    // MARK: Item resources
    
    /// The date the item was created.
    static var CreationDate: WritableResource<NSDate> {
        return writableObject(NSURLCreationDateKey)
    }
    
    /// The time the item's content was last modified.
    static var ContentModificationDate:   WritableResource<NSDate> {
        return writableObject(NSURLContentModificationDateKey)
    }
    
    /// The time the item's attributes were last modified.
    static var AttributeModificationDate: WritableResource<NSDate> {
        return writableObject(NSURLAttributeModificationDateKey)
    }
    
    /// The custom icon assigned to the resource, if any.
    ///
    /// :warning: Currently not implemented in Foundation.
    @availability(*, unavailable)
    static var CustomIcon: WritableResource<ImageType> {
        return writableObject(NSURLCustomIconKey)
    }
    
    /// The file system object's security information.
    static var FileSecurity: WritableResource<NSFileSecurity> {
        return writableObject(NSURLFileSecurityKey)
    }
    
    /// Whether resource should be excluded from backups.
    static var IsExcludedFromBackup: WritableResource<Bool> {
        return writable(NSURLIsExcludedFromBackupKey)
    }
    
    #if os(OSX)
    
    /// The array of Tag names.
    static var TagNames: WritableResource<[String]> {
        return writable(NSURLTagNamesKey)
    }
    
    // The quarantine properties as defined in `LaunchServices.LSQuarantine`.
    // To remove quarantine information from a file, pass NSNull as the value when setting this property. (Read-write, value type NSDictionary)
    static var QuarantineAttributes: WritableResource<Quarantine> {
        return writableConvert(NSURLQuarantinePropertiesKey)
    }
    
    #endif
    
    /// Dictionary of `NSImage` or `UIImage` objects keyed by size.
    ///
    /// :availability: Mac OS X 10.10 and iOS 8.0
    static var Thumbnails: WritableResource<[ThumbnailSize: ImageType]> {
        return writableOf(NSURLThumbnailDictionaryKey, writer: ThumbnailSize.writeDictionary)
    }
    
    // MARK: Volume resources
    
    /// The name of the volume.
    ///
    /// Though this resource is writable, if the volume does not support
    /// renaming, writes will always fail.
    ///
    /// :see: VolumeSupportsRenaming
    static var VolumeName: WritableResource<String> {
        return writable(NSURLVolumeNameKey)
    }
    
}
