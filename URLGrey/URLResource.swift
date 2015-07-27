//
//  URLResource.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 10/21/14.
//  Copyright (c) 2014 Zachary Waldowski. All rights reserved.
//

import Foundation

// MARK: URL Resource Prototypes

/// A static namespace providing prototypes for resources that may be read from
/// or written to URLs.
public struct URLResource {
    
    private init() {}

    // MARK: Item resources
    
    /// The resource name provided by the file system.
    public static let Name = URLResourceBridgedRead<String>(key: NSURLNameKey)
    /// Localized or extension-hidden name as displayed to users.
    public static let LocalizedName = URLResourceBridgedRead<String>(key: NSURLLocalizedNameKey)
    /// True for regular files.
    public static let IsRegularFile = URLResourceBridgedRead<Bool>(key: NSURLIsRegularFileKey)
    /// True for directories.
    public static let IsDirectory = URLResourceBridgedRead<Bool>(key: NSURLIsDirectoryKey)
    /// True for symlinks.
    public static let IsSymbolicLink = URLResourceBridgedRead<Bool>(key: NSURLIsSymbolicLinkKey)
    /// Whether the URL represents the root directory of a volume.
    public static let IsVolume = URLResourceBridgedRead<Bool>(key: NSURLIsVolumeKey)
    /// Whether the URL represents a directory that appears as a file unit.
    public static let IsPackage = URLResourceBridgedRead<Bool>(key: NSURLIsPackageKey)
    /// Whether the URL represents an application.
    @available(OSX 10.11, iOS 9.0, watchOS 2.0, *)
    public static let IsApplication = URLResourceBridgedRead<Bool>(key: NSURLIsApplicationKey)
    #if os(OSX)
    @available(OSX 10.11, *)
    public static let ApplicationIsScriptable = URLResourceBridgedRead<Bool>(key: NSURLApplicationIsScriptableKey)
    #endif
    /// Whether the item cannot be written to by the system.
    public static let IsSystemImmutable = URLResourceBridgedRead<Bool>(key: NSURLIsSystemImmutableKey)
    /// Whether the item cannot be written to by the user.
    public static let IsUserImmutable = URLResourceBridgedRead<Bool>(key: NSURLIsUserImmutableKey)
    /// Whether the item is normally not displayed to users.
    public static let IsHidden = URLResourceBridgedRead<Bool>(key: NSURLIsHiddenKey)
    /// Whether the filename extension is removed from the localized name.
    public static let HasHiddenExtension = URLResourceBridgedRead<Bool>(key: NSURLHasHiddenExtensionKey)
    /// The date the item was created.
    public static let CreationDate = URLResourceObjectWrite<NSDate>(key: NSURLCreationDateKey)
    /// The date the item was last accessed.
    public static let ContentAccessDate = URLResourceObjectRead<NSDate>(key: NSURLContentAccessDateKey)
    /// The time the item's content was last modified.
    public static let ContentModificationDate = URLResourceObjectWrite<NSDate>(key: NSURLContentModificationDateKey)
    /// The time the item's attributes were last modified.
    public static let AttributeModificationDate = URLResourceObjectWrite<NSDate>(key: NSURLAttributeModificationDateKey)
    /// Number of hard links to the item.
    public static let LinkCount = URLResourceBridgedRead<Int>(key: NSURLLinkCountKey)
    /// The item's parent directory, if any.
    public static let ParentDirectoryURL = URLResourceObjectRead<NSURL>(key: NSURLParentDirectoryURLKey)
    /// URL of the volume on which the item is stored.
    public static let VolumeURL = URLResourceObjectRead<NSURL>(key: NSURLVolumeURLKey)
    /// Uniform type identifier (UTI) for the resource.
    public static let TypeIdentifier = URLResourceConvertRead<UTI>(key: NSURLTypeIdentifierKey)
    /// User-visible type or "kind" description.
    public static let LocalizedTypeDescription = URLResourceBridgedRead<String>(key: NSURLLocalizedTypeDescriptionKey)
    /// The icon normally displayed for the resource.
    public static let EffectiveIcon = URLResourceObjectRead<ImageType>(key: NSURLEffectiveIconKey)
    /// The custom icon assigned to the resource, if any.
    ///
    /// :warning: Currently not implemented in Foundation.
    @available(*, unavailable)
    public static let CustomIcon = URLResourceObjectWrite<ImageType>(key: NSURLCustomIconKey)
    /// An identifier that can be used to compare two file system objects for
    /// equality.
    ///
    /// Two object identifiers are equal if they have the same path
    /// or if the paths are linked to same node on the same file system.
    ///
    /// :note: The identifier is not persistent across system restarts.
    public static let FileIdentifier = URLResourceObjectRead<OpaqueType>(key: NSURLFileResourceIdentifierKey)
    /// An identifier that can be used to identify the volume the file system
    /// object is on.
    ///
    /// Other objects on the same volume will have the same volume identifier
    /// and can be compared for equality.
    ///
    /// :note: This identifier is not persistent across system restarts.
    public static let VolumeIdentifier = URLResourceObjectRead<OpaqueType>(key: NSURLVolumeIdentifierKey)
    /// The optimal block size when reading or writing this file's data.
    public static let PreferredIOBlockSize = URLResourceBridgedRead<Int>(key: NSURLPreferredIOBlockSizeKey)
    /// Whether this process (as determined by EUID) can read from the URL.
    public static let IsReadable = URLResourceBridgedRead<Bool>(key: NSURLIsReadableKey)
    /// Whether this process (as determined by EUID) can write to the URL.
    public static let IsWritable = URLResourceBridgedRead<Bool>(key: NSURLIsWritableKey)
    /// Whether this process (as determined by EUID) can execute a file at a
    /// URL or search a directory at a URL.
    public static let IsExecutable = URLResourceBridgedRead<Bool>(key: NSURLIsExecutableKey)
    /// The file system object's security information.
    public static let FileSecurity = URLResourceObjectWrite<NSFileSecurity>(key: NSURLFileSecurityKey)
    /// Whether the item should be excluded from backups.
    public static let IsExcludedFromBackup = URLResourceBridgedWrite<Bool>(key: NSURLIsExcludedFromBackupKey)
    /// The URL's path as a file system path.
    public static let Path = URLResourceBridgedRead<String>(key: NSURLPathKey)
    /// Whether this URL is a file system trigger directory.
    ///
    /// Traversing or opening a file system trigger will cause an attempt to
    /// mount a file system on the trigger directory.
    public static let IsMountTrigger = URLResourceBridgedRead<Bool>(key: NSURLIsMountTriggerKey)
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
    @available(OSX 10.10, iOS 8.0, *)
    public static let GenerationIdentifier = URLResourceObjectRead<OpaqueType>(key: NSURLGenerationIdentifierKey)
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
    @available(OSX 10.10, iOS 8.0, *)
    public static let DocumentIdentifier = URLResourceObjectRead<OpaqueType>(key: NSURLDocumentIdentifierKey)
    /// The date the resource was created, renamed into, or renamed within its
    /// parent directory.
    ///
    /// Inconsistent behavior may be observed when this attribute is
    /// requested on hard-linked items.
    ///
    /// :note: This resource is not supported by all volumes.
    @available(OSX 10.10, iOS 8.0, *)
    public static let AddedToDirectoryDate = URLResourceObjectRead<NSDate>(key: NSURLAddedToDirectoryDateKey)
    /// The file system object type.
    ///
    /// :see: FileClass
    public static let ObjectType = URLResourceConvertRead<FileClass>(key: NSURLFileResourceTypeKey)
    #if os(OSX)
    /// The array of Tag names.
    public static let TagNames = URLResourceBridgedWrite<[String]>(key: NSURLTagNamesKey)
    // The quarantine properties as defined in `LaunchServices`.
    @available(OSX 10.10, *)
    public static let QuarantineAttributes = URLResourceConvertWrite<Quarantine>(key: NSURLQuarantinePropertiesKey)
    /// All thumbnails as a single multi-representation image.
    @available(OSX 10.10, *)
    public static let ThumbnailImage = URLResourceObjectRead<ImageType>(key: NSURLThumbnailKey)
    #endif
    @available(OSX 10.10, iOS 8.0, *)
    public static let Thumbnails = URLResourceThumbnails()
    
    // MARK: File resources
    
    /// Total file size in bytes.
    public static let FileSize = URLResourceBridgedRead<Int>(key: NSURLFileSizeKey)
    /// Total size allocated on disk for the file in bytes.
    ///
    /// This value is equivalent to number of blocks times block size.
    public static let FileAllocatedSize = URLResourceBridgedRead<Int>(key: NSURLFileAllocatedSizeKey)
    /// Total displayable size of the file in bytes.
    ///
    /// This may include space used by metadata.
    public static let TotalFileSize = URLResourceBridgedRead<Int>(key: NSURLTotalFileSizeKey)
    /// Total allocated size of the file in bytes.
    ///
    /// This value may include space used by metadata. It maybe can be
    /// less than the total file size if the resource is compressed.
    public static let TotalFileAllocatedSize = URLResourceBridgedRead<Int>(key: NSURLTotalFileAllocatedSizeKey)
    /// Whether the resource is a Finder alias file or a symbolic link.
    public static let FileIsAlias = URLResourceBridgedRead<Bool>(key: NSURLIsAliasFileKey)
    #if os(iOS) || os(watchOS)
    @available(iOS 9.0, watchOS 2.0, *)
    public static let FileProtectionType = URLResourceConvertWrite<FileProtection>(key: NSURLFileProtectionKey)
    #endif
    
    // MARK: Volume resources
    
    /// The user-visible localized volume format.
    public static let VolumeLocalizedFormatDescription = URLResourceBridgedRead<String>(key: NSURLVolumeLocalizedFormatDescriptionKey)
    /// Total volume capacity in bytes.
    public static let VolumeTotalCapacity = URLResourceBridgedRead<Int>(key: NSURLVolumeTotalCapacityKey)
    /// Total volume free space in bytes.
    public static let VolumeAvailableCapacity = URLResourceBridgedRead<Int>(key: NSURLVolumeAvailableCapacityKey)
    /// Total number of resources on the volume.
    public static let VolumeResourceCount = URLResourceBridgedRead<Int>(key: NSURLVolumeResourceCountKey)
    /// Whether the volume format supports persistent object identifiers
    /// and can look up file system objects by their IDs.
    public static let VolumeSupportsPersistentIDs = URLResourceBridgedRead<Bool>(key: NSURLVolumeSupportsPersistentIDsKey)
    /// Whether the volume format supports symbolic links.
    public static let VolumeSupportsSymbolicLinks = URLResourceBridgedRead<Bool>(key: NSURLVolumeSupportsHardLinksKey)
    /// Whether the volume format supports hard links.
    public static let VolumeSupportsHardLinks = URLResourceBridgedRead<Bool>(key: NSURLVolumeSupportsJournalingKey)
    /// Whether the volume format supports a journal used to speed recovery
    /// in case of unplanned restart (such as a power outage or crash). This
    /// does not necessarily mean the volume is actively using a journal.
    ///
    /// :see: VolumeIsJournaling
    public static let VolumeSupportsJournaling = URLResourceBridgedRead<Bool>(key: NSURLVolumeSupportsJournalingKey)
    /// Whether the volume is currently using a journal for speedy recovery
    /// after an unplanned restart.
    public static let VolumeIsJournaling = URLResourceBridgedRead<Bool>(key: NSURLVolumeIsJournalingKey)
    /// Whether the volume format supports sparse files.
    ///
    /// Sparse files can have 'holes' that have never been written to, and
    /// thus do not consume space on disk. A sparse file may have an
    /// allocated size on disk that is less than its logical length.
    public static let VolumeSupportsSparseFiles = URLResourceBridgedRead<Bool>(key: NSURLVolumeSupportsSparseFilesKey)
    /// Whether the volume keeps track of allocated but unwritten runs of a
    /// file so that it can substitute zeroes without actually writing
    /// zeroes to the media.
    ///
    /// For security reasons, parts of a file (runs) that have never been
    /// written to must appear to contain zeroes.
    public static let VolumeSupportsZeroRuns = URLResourceBridgedRead<Bool>(key: NSURLVolumeSupportsZeroRunsKey)
    /// Whether the volume format treats upper and lower case characters in
    /// file and directory names as different.
    ///
    /// If the volume is not case-aware, an upper case character is
    /// equivalent to a lower case character, and you can't have two names
    /// that differ solely in the case of the characters.
    public static let SupportsCaseSensitiveNames = URLResourceBridgedRead<Bool>(key: NSURLVolumeSupportsCaseSensitiveNamesKey)
    /// Whether the volume format preserves the case of file and directory
    /// names.
    ///
    /// If the volume does not preserve case, it may change the case of some
    /// characters (typically making them all upper or all lower case).
    public static let VolumeSupportsCasePreservedNames = URLResourceBridgedRead<Bool>(key: NSURLVolumeSupportsCasePreservedNamesKey)
    /// Whether the volume supports reliable storage of times for the root
    /// directory.
    public static let VolumeSupportsRootDirectoryDates = URLResourceBridgedRead<Bool>(key: NSURLVolumeSupportsRootDirectoryDatesKey)
    /// Whether the volume supports returning volume size values.
    ///
    /// :see: VolumeTotalCapacity
    /// :see: VolumeAvailableCapacity
    public static let VolumeSupportsVolumeSizes = URLResourceBridgedRead<Bool>(key: NSURLVolumeSupportsVolumeSizesKey)
    /// Whether the volume can be renamed.
    public static let VolumeSupportsRenaming = URLResourceBridgedRead<Bool>(key: NSURLVolumeSupportsRenamingKey)
    /// locks, and the `O_EXLOCK` and `O_SHLOCK` flags of the `open(2)`
    /// call.
    public static let VolumeSupportsAdvisoryFileLocking = URLResourceBridgedRead<Bool>(key: NSURLVolumeSupportsAdvisoryFileLockingKey)
    public static let VolumeSupportsExtendedSecurity = URLResourceBridgedRead<Bool>(key: NSURLVolumeSupportsExtendedSecurityKey)
    /// Desktop in the Finder.
    public static let VolumeIsBrowsable = URLResourceBridgedRead<Bool>(key: NSURLVolumeIsBrowsableKey)
    /// The largest file size (in bytes) supported by this file system.
    public static let VolumeMaximumFileSize = URLResourceBridgedRead<Int>(key: NSURLVolumeMaximumFileSizeKey)
    /// Whether the volume's media is ejectable from the drive mechanism
    /// under software control.
    public static let VolumeIsEjectable = URLResourceBridgedRead<Bool>(key: NSURLVolumeIsEjectableKey)
    /// Whether the volume's media is removable from the drive mechanism.
    public static let VolumeIsRemovable = URLResourceBridgedRead<Bool>(key: NSURLVolumeIsRemovableKey)
    /// Whether the volume's device is connected to an internal bus.
    public static let VolumeIsInternal = URLResourceBridgedRead<Bool>(key: NSURLVolumeIsInternalKey)
    /// Whether the volume is automounted.
    ///
    /// :note: Not to be mistaken for the volume being browsable; the
    ///        volume may be mounted but not visible to the user.
    /// :see: VolumeIsBrowsable
    public static let VolumeIsAutomounted = URLResourceBridgedRead<Bool>(key: NSURLVolumeIsAutomountedKey)
    /// Whether the volume is stored on a local device.
    public static let VolumeIsLocal = URLResourceBridgedRead<Bool>(key: NSURLVolumeIsLocalKey)
    /// Whether the volume is read-only.
    public static let VolumeIsReadOnly = URLResourceBridgedRead<Bool>(key: NSURLVolumeIsReadOnlyKey)
    /// The volume's creation date.
    public static let VolumeCreationDate = URLResourceObjectRead<NSDate>(key: NSURLVolumeCreationDateKey)
    /// The URL needed to remount a network volume.
    public static let VolumeURLForRemounting = URLResourceObjectRead<NSURL>(key: NSURLVolumeURLForRemountingKey)
    /// The volume's persistent UUID.
    public static let VolumeUUID = URLResourceBridgedRead<String>(key: NSURLVolumeUUIDStringKey)
    /// The name of the volume.
    ///
    /// Though this resource is writable, if the volume does not support
    /// renaming, writes will always fail.
    ///
    /// :see: VolumeSupportsRenaming
    public static let VolumeName = URLResourceBridgedWrite<String>(key: NSURLVolumeNameKey)
    /// The user-friendly presentable name of the volume.
    public static let VolumeLocalizedName = URLResourceBridgedRead<String>(key: NSURLVolumeLocalizedNameKey)
    
    // MARK: Ubiquitous item resources
    
    /// Whether this item is synced to the cloud or is only a local file.
    public static let IsUbiquitous = URLResourceBridgedRead<Bool>(key: NSURLIsUbiquitousItemKey)
    /// Whether this item has conflicts outstanding.
    public static let UbiquityHasUnresolvedConflicts = URLResourceBridgedRead<Bool>(key: NSURLUbiquitousItemHasUnresolvedConflictsKey)
    /// Whether data is being downloaded for this item.
    public static let UbiquityIsDownloading = URLResourceBridgedRead<Bool>(key: NSURLUbiquitousItemIsDownloadingKey)
    /// Whether there is data present in the cloud for this item.
    public static let UbiquityIsUploaded = URLResourceBridgedRead<Bool>(key: NSURLUbiquitousItemIsUploadedKey)
    /// Whether data is being uploaded for this item.
    public static let UbiquityIsUploading = URLResourceBridgedRead<Bool>(key: NSURLUbiquitousItemIsUploadingKey)
    /// The download status of this item.
    public static let UbiquityDownloadingStatus = URLResourceConvertRead<UbiquitousStatus>(key: NSURLUbiquitousItemDownloadingStatusKey)
    /// The error when downloading the item from iCloud failed.
    ///
    /// :see: Foundation.NSCocoaError.isUbiquitousFileError
    public static let UbiquityDownloadingError = URLResourceErrorRead<NSCocoaError>(key: NSURLUbiquitousItemDownloadingErrorKey)
    /// The error when uploading the item to iCloud failed.
    ///
    /// :see: Foundation.NSCocoaError.isUbiquitousFileError
    public static let UbiquityUploadingError = URLResourceErrorRead<NSCocoaError>(key: NSURLUbiquitousItemUploadingErrorKey)
    /// Whether a download of this item has already been requested.
    ///
    /// :see: Foundation.NSFileManager.startDownloadingUbiquitousItemAtURL(_:)
    @available(OSX 10.10, iOS 8.0, *)
    public static let UbiquityDownloadRequested = URLResourceBridgedRead<Bool>(key: NSURLUbiquitousItemDownloadRequestedKey)
    /// The name of this item's container as displayed to users.
    @available(OSX 10.10, iOS 8.0, *)
    static var UbiquityContainerDisplayName = URLResourceBridgedRead<String>(key: NSURLUbiquitousItemContainerDisplayNameKey)
    
}
