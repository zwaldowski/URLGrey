//
//  UTI+CoreTypes.swift
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

public extension UTI {
    
    // MARK: Basic types
    /// generic base type for most things
    /// (files, directories)
    public static var Item:             UTI { return UTI(kUTTypeItem) }
    /// base type for anything containing user-viewable document content
    /// (documents, pasteboard data, and document packages)
    public static var Content:          UTI { return UTI(kUTTypeContent) }
    /// base type for content formats supporting mixed embedded content
    /// (i.e., compound documents)
    public static var CompositeContent: UTI { return UTI(kUTTypeCompositeContent) }
    /// base type for messages (email, IM, etc.)
    public static var Message:          UTI { return UTI(kUTTypeMessage) }
    /// contact information, e.g. for a person, group, organization
    public static var Contact:          UTI { return UTI(kUTTypeContact) }
    /// an archive of files and directories
    public static var Archive:          UTI { return UTI(kUTTypeArchive) }
    /// a data item mountable as a volume
    public static var DiskImage:        UTI { return UTI(kUTTypeDiskImage) }
    
    // MARK: File system objects
    /// base type for any sort of simple byte stream,
    /// including files and in-memory data
    public static var Data:         UTI { return UTI(kUTTypeData) }
    /// file system directory
    /// (includes packages AND folders)
    public static var Directory:    UTI { return UTI(kUTTypeDirectory) }
    /// symlink and alias file types conform to this UTI
    public static var Resolvable:   UTI { return UTI(kUTTypeResolvable) }
    /// a symbolic link
    public static var SymbolicLink: UTI { return UTI(kUTTypeSymLink) }
    /// an executable item
    public static var Executable:   UTI { return UTI(kUTTypeExecutable) }
    /// a volume mount point (resolvable, resolves to the root dir of a volume)
    public static var MountPoint:   UTI { return UTI(kUTTypeMountPoint) }
    /// a fully-formed alias file
    public static var AliasFile:    UTI { return UTI(kUTTypeAliasFile) }
    /// raw alias data
    public static var AliasRecord:  UTI { return UTI(kUTTypeAliasRecord) }
    /// URL bookmark
    /// @note: Introduced in 10.10 and soft-backported
    public static var URLBookmark:  UTI { return UTI("com.apple.bookmark") }

    // MARK: Cocoa
    /// The bytes of a URL
    public static var URL:                     UTI { return UTI(kUTTypeURL) }
    /// The text of a "file:" URL
    public static var FileURL:                 UTI { return UTI(kUTTypeFileURL) }
    #if os(OSX)
    /// a file url on the pasteboard to a file which does not yet exist
    public static var PromisedFileURL:         UTI { return UTI("com.apple.pasteboard.promised-file-url") }
    /// a UTI string describing the type of data to be contained within the promised file
    public static var PromisedFileContentType: UTI { return UTI("com.apple.pasteboard.promised-file-content-type") }
    #endif
    
    // MARK: Text
    /// base type for all text-encoded data,
    /// including text with markup (HTML, RTF, etc.)
    public static var Text:               UTI { return UTI(kUTTypeText) }
    /// text with no markup, unspecified encoding
    public static var Plain:              UTI { return UTI(kUTTypePlainText) }
    /// plain text, UTF-8 encoding
    public static var PlainUTF8:          UTI { return UTI(kUTTypeUTF8PlainText) }
    /// plain text, UTF-16 encoding, with BOM, or if BOM
    /// is not present, has "external representation"
    public static var ExternalPlainUTF16: UTI { return UTI(kUTTypeUTF16ExternalPlainText) }
    /// plain text, UTF-16 encoding, native byte order, optional BOM
    public static var PlainUTF16:         UTI { return UTI(kUTTypeUTF16PlainText) }
    /// text containing delimited values
    /// @note: Introduced in 10.10 and soft-backported
    public static var Delimited:          UTI { return UTI("public.delimited-values-text") }
    /// text containing comma-separated values (.csv)
    /// @note: Introduced in 10.10 and soft-backported
    public static var CommaSeparated:     UTI { return UTI("public.comma-separated-values-text") }
    /// text containing tab-separated values
    /// @note: Introduced in 10.10 and soft-backported
    public static var TabSeparated:       UTI { return UTI("public.tab-separated-values-text") }
    /// UTF-8 encoded text containing tab-separated values
    /// @note: Introduced in 10.10 and soft-backported
    public static var TabSeparatedUTF8:   UTI { return UTI("public.utf8-tab-separated-values-text") }
    /// Rich Text Format (.rtf)
    public static var Rich:               UTI { return UTI(kUTTypeRTF) }
    
    // MARK: Markup
    /// HTML, any version (.html)
    public static var HTML:     UTI { return UTI(kUTTypeHTML) }
    /// generic XML (.xml)
    public static var XML:      UTI { return UTI(kUTTypeXML) }
    /// typesetting for mathematical formulae (.tex)
    public static var TeX:      UTI { return UTI("org.tug.tex") }
    /// transformation and styling for XML documents (.xsl)
    public static var XSLT:     UTI { return UTI("org.w3.xsl") }
    /// plain text formatted markup (.markdown, .md, .mdown)
    public static var Markdown: UTI { return UTI("net.daringfireball.markdown") }
    
    // MARK: Source code
    /// abstract type for source code; any language
    public static var SourceCode: UTI { return UTI(kUTTypeSourceCode) }
    /// assembly language source (.s)
    /// @note: Introduced in 10.10 and soft-backported
    public static var Assembly:   UTI { return UTI("public.assembly-source") }
    /// C source code (.c)
    public static var C:          UTI { return UTI(kUTTypeCSource) }
    /// Objective-C source code (.m)
    public static var ObjC:       UTI { return UTI(kUTTypeObjectiveCSource) }
    /// C++ source code (.cp, etc.)
    public static var CPP:        UTI { return UTI(kUTTypeCPlusPlusSource) }
    /// Objective-C++ source code (.mm)
    public static var ObjCPP:     UTI { return UTI(kUTTypeObjectiveCPlusPlusSource) }
    /// C header (.h)
    public static var CHeader:    UTI { return UTI(kUTTypeCHeader) }
    /// C++ header (.h, .hh, .hpp)
    public static var CPPHeader:  UTI { return UTI(kUTTypeCPlusPlusHeader) }
    /// Java source code (.java)
    public static var Java:       UTI { return UTI(kUTTypeJavaSource) }
    /// Swift source code (.swift)
    public static var Swift:      UTI { return UTI("public.swift-source") }
    /// C# source code (.cs)
    public static var CSharp:     UTI { return UTI("com.microsoft.csharp-source") }
    /// Groovy source code (.groovy)
    public static var Groovy:     UTI { return UTI("org.codehaus.groovy-source") }
    /// Erlang source code (.erl)
    public static var Erlang:     UTI { return UTI("org.erlang.erlang-source") }
    /// Rust source code (.rs)
    public static var Rust:       UTI { return UTI(preferredTag: .FilenameExtension("rs"), conformingTo: SourceCode) }
    /// Go source code (.rs)
    public static var GoLang:     UTI { return UTI(preferredTag: .FilenameExtension("go"), conformingTo: SourceCode) }

    // MARK: Scripts
    /// scripting language source
    /// @note: Introduced in 10.10 and soft-backported
    public static var Script:       UTI { return UTI("public.script") }
    /// AppleScript text format (.applescript)
    /// @note: Introduced in 10.10 and soft-backported
    public static var AppleScript:  UTI { return UTI("com.apple.applescript.text") }
    /// Open Scripting Architecture script binary format (.scpt)
    /// @note: Introduced in 10.10 and soft-backported
    public static var OSABinary:    UTI { return UTI("com.apple.applescript.script") }
    /// Open Scripting Architecture script bundle format (.scptd)
    /// @note: Introduced in 10.10 and soft-backported
    public static var OSABundle:    UTI { return UTI("com.apple.applescript.script-bundle") }
    /// JavaScript source code (.js)
    /// @note: Introduced in 10.10 and soft-backported
    public static var JavaScript:   UTI { return UTI("com.netscape.javascript-source") }
    /// base type for shell scripts (.sh)
    /// @note: Introduced in 10.10 and soft-backported
    public static var Shell:        UTI { return UTI("public.shell-script") }
    /// Perl script (.pl)
    /// @note: Introduced in 10.10 and soft-backported
    public static var Perl:         UTI { return UTI("public.perl-script") }
    /// Python script (.py)
    /// @note: Introduced in 10.10 and soft-backported
    public static var Python:       UTI { return UTI("public.python-script") }
    /// Ruby script (.rb)
    /// @note: Introduced in 10.10 and soft-backported
    public static var Ruby:         UTI { return UTI("public.ruby-script") }
    /// PHP script (.php)
    /// @note: Introduced in 10.10 and soft-backported
    public static var PHP:          UTI { return UTI("public.php-script") }
    /// ASP script (.asp)
    public static var ASP:          UTI { return UTI("com.microsoft.asp") }
    /// Visual Basic script (.vb)
    public static var VisualBasic:  UTI { return UTI("com.microsoft.vb-source") }
    /// CoffeeScript source (.coffee)
    public static var CoffeeScript: UTI { return UTI("org.coffeescript.coffeescript") }
    /// Lua script (.lua)
    public static var Lua:          UTI { return UTI("org.lua.lua-source") }
    /// OCaml script (.ml)
    public static var OCaml:        UTI { return UTI("org.ocaml.ocaml-source") }
    /// Scala script (.scala)
    public static var Scala:        UTI { return UTI("org.scala-lang.scala") }
    /// Swig script (.i, .swg)
    public static var Swig:         UTI { return UTI("org.swig.swig") }
    
    // MARK: Serialized data
    /// JavaScript object notation data (.json)
    /// @note JSON almost but doesn't quite conform to JavaScript source
    /// @see UTI.JavaScript
    /// @note: Introduced in 10.10 and soft-backported
    public static var JSON:               UTI { return UTI("public.json") }
    /// base type for property lists (.plist)
    /// @note: Introduced in 10.10 and soft-backported
    public static var PropertyList:       UTI { return UTI("com.apple.property-list") }
    /// XML property list
    /// @note: Introduced in 10.10 and soft-backported
    public static var PropertyListXML:    UTI { return UTI("com.apple.xml-property-list") }
    /// Binary property list
    /// @note: Introduced in 10.10 and soft-backported
    public static var PropertyListBinary: UTI { return UTI("com.apple.binary-property-list") }
    /// plain text markup for structured data (.yaml)
    public static var YAML:               UTI { return UTI("org.yaml.yaml") }
    /// XML markup for outlines (.opml)
    public static var OPML:               UTI { return UTI("org.opml.opml") }
    /// plain text markup for textual data (.rst)
    public static var ReStructuredText:   UTI { return UTI("org.python.restructuredtext") }
    
    // MARK: Composite contents
    /// Adobe PDF (.pdf)
    public static var PDF:        UTI { return UTI(kUTTypePDF) }
    /// Rich Text Format Directory (.rtfd)
    public static var RTFD:       UTI { return UTI(kUTTypeRTFD) }
    /// Flattened RTFD; pasteboard format
    public static var RTFDFlat:   UTI { return UTI(kUTTypeFlatRTFD) }
    /// MLTE (Textension) format for mixed text & multimedia data
    public static var Textension: UTI { return UTI(kUTTypeTXNTextAndMultimediaData) }
    /// The WebKit webarchive format (.webarchive)
    public static var WebArchive: UTI { return UTI(kUTTypeWebArchive) }
    /// Adobe language for vectors (.ps)
    public static var PostScript: UTI { return UTI("com.adobe.postscript") }
    
    // MARK: Graphics
    /// abstract image data
    public static var Image:          UTI { return UTI(kUTTypeImage) }
    /// JPEG image (.jpeg, .jpg)
    public static var JPEG:           UTI { return UTI(kUTTypeJPEG) }
    /// JPEG-2000 image (.jp2)
    public static var JPEG2000:       UTI { return UTI(kUTTypeJPEG2000) }
    /// TIFF image (.tiff, .tif)
    public static var TIFF:           UTI { return UTI(kUTTypeTIFF) }
    /// Quickdraw PICT format (.pict)
    public static var PICT:           UTI { return UTI(kUTTypePICT) }
    /// GIF image, pronounced with a hard "G" (.gif)
    public static var GIF:            UTI { return UTI(kUTTypeGIF) }
    /// PNG image (.png)
    public static var PNG:            UTI { return UTI(kUTTypePNG) }
    /// QuickTime image format (.qtif)
    public static var QuickTimeImage: UTI { return UTI(kUTTypeQuickTimeImage) }
    /// Apple icon data (.icns)
    public static var Icon:           UTI { return UTI(kUTTypeAppleICNS) }
    /// Windows bitmap (.bmp)
    public static var WindowsBitmap:  UTI { return UTI(kUTTypeBMP) }
    /// Windows icon data (.ico)
    public static var WindowsIcon:    UTI { return UTI(kUTTypeICO) }
    /// base type for raw image data (.raw)
    /// @note: Introduced in 10.10 and soft-backported
    public static var Raw:            UTI { return UTI("public.camera-raw-image") }
    /// SVG image (.svg)
    /// @note: Introduced in 10.10 and soft-backported
    public static var ScalableVector: UTI { return UTI("public.svg-image") }
    /// Google WebP image (.webp)
    public static var WebP:           UTI { return UTI("com.google.webp") }
    /// Adobe Photoshop® document (.psd)
    public static var Photoshop:      UTI { return UTI("com.adobe.photoshop-image") }

    // MARK: Media
    /// audio and/or video content
    public static var Media:        UTI { return UTI(kUTTypeAudiovisualContent) }
    /// A media format which may contain both video and audio
    /// Corresponds to what users would label a "movie"
    public static var Movie:        UTI { return UTI(kUTTypeMovie) }
    /// pure video; no audio
    public static var Video:        UTI { return UTI(kUTTypeVideo) }
    /// pure audio; no video
    public static var Audio:        UTI { return UTI(kUTTypeAudio) }
    /// QuickTime movie (.mov)
    public static var QuickTime:    UTI { return UTI(kUTTypeQuickTimeMovie) }
    /// MPEG-1 or MPEG-2 movie (,mpeg, ,mpg)
    /// @note: Introduced in 10.10 and soft-backported
    public static var MPEG:         UTI { return UTI("public.mpeg") }
    /// MPEG-2 video (.mp2)
    /// @note: Introduced in 10.10 and soft-backported
    public static var MP2:          UTI { return UTI("public.mpeg-2-video") }
    /// MPEG-2 Transport Stream movie format (.ts, .m2ts)
    /// @note: Introduced in 10.10 and soft-backported
    public static var MP2TS:        UTI { return UTI("public.mpeg-2-transport-stream") }
    /// MPEG-3 audio (.mp3)
    public static var MP3:          UTI { return UTI(kUTTypeMP3) }
    /// MPEG-4 movie (.mp4)
    public static var MP4:          UTI { return UTI(kUTTypeMPEG4) }
    /// MPEG-4 audio layer (.m4a)
    public static var M4A:          UTI { return UTI(kUTTypeMPEG4Audio) }
    /// Apple protected iTunes music store format (.m4p)
    /// @note: Introduced in 10.10 and soft-backported
    public static var M4AProtected: UTI { return UTI("com.apple.protected-mpeg-4-audio") }
    /// Apple protected MPEG-4 movie (.m4v)
    /// @note: Introduced in 10.10 and soft-backported
    public static var M4VProtected: UTI { return UTI("com.apple.protected-mpeg-4-video") }
    /// Audio Video Interleaved movie format (.avi)
    public static var AVI:          UTI { return UTI("public.avi") }
    /// AIFF audio format (.aiff, .aif)
    /// @note: Introduced in 10.10 and soft-backported
    public static var AIFF:         UTI { return UTI("public.aiff-audio") }
    /// Waveform audio format (.wav)
    /// @note: Introduced in 10.10 and soft-backported
    public static var WAV:          UTI { return UTI("com.microsoft.waveform-audio") }
    /// MIDI audio format (.mid)
    /// @note: Introduced in 10.10 and soft-backported
    public static var MIDI:         UTI { return UTI("public.midi-audio") }
    /// base type for playlists
    /// @note: Introduced in 10.10 and soft-backported
    public static var Playlist:     UTI { return UTI("public.playlist") }
    /// M3U or M3U8 playlist (.m3u, .m3u8)
    /// @note: Introduced in 10.10 and soft-backported
    public static var PlaylistM3U:  UTI { return UTI("public.m3u-playlist") }
    
    // MARK: Folders
    /// a user-browsable directory (i.e., not a package)
    public static var Folder:    UTI { return UTI(kUTTypeFolder) }
    /// the root folder of a volume/mount point
    public static var Volume:    UTI { return UTI(kUTTypeVolume) }
    /// a packaged directory
    public static var Package:   UTI { return UTI(kUTTypePackage) }
    /// a directory conforming to one of the Cocoa bundle layouts (.bundle)
    public static var Bundle:    UTI { return UTI(kUTTypeBundle) }
    /// base type for bundle-based plugins (.plugin)
    /// @note: Introduced in 10.10 and soft-backported
    public static var Plugin:    UTI { return UTI("com.apple.plugin") }
    /// a Spotlight metadata importer (.mdimporter)
    /// @note: Introduced in 10.10 and soft-backported
    public static var Spotlight: UTI { return UTI("com.apple.metadata-importer") }
    /// a QuickLook preview generator (.qlgenerator)
    /// @note: Introduced in 10.10 and soft-backported
    public static var QuickLook: UTI { return UTI("com.apple.quicklook-generator") }
    /// an XPC service (.xpc)
    /// @note: Introduced in 10.10 and soft-backported
    public static var XPC:       UTI { return UTI("com.apple.xpc-service") }
    /// a Mac OS X framework (.framework)
    public static var Framework: UTI { return UTI(kUTTypeFramework) }

    // MARK: Executables
    /// base type for OS X applications, launchable items
    public static var App:            UTI { return UTI(kUTTypeApplication) }
    /// a bundled application (.app)
    public static var AppBundle:      UTI { return UTI(kUTTypeApplicationBundle) }
    /// a single-file Carbon/Classic application
    public static var AppClassic:     UTI { return UTI(kUTTypeApplicationFile) }
    /// a UNIX executable (flat file)
    /// @note: Introduced in 10.10 and soft-backported
    public static var AppUnix:        UTI { return UTI("public.unix-executable") }
    /// a Windows executable (.exe)
    /// @note: Introduced in 10.10 and soft-backported
    public static var AppWindows:     UTI { return UTI("com.microsoft.windows-executable") }
    /// a Java class (.class)
    /// @note: Introduced in 10.10 and soft-backported
    public static var JavaClass:      UTI { return UTI("com.sun.java-class") }
    /// a System Preferences pane (.prefpane)
    /// @note: Introduced in 10.10 and soft-backported
    public static var PreferencePane: UTI { return UTI("com.apple.systempreference.prefpane") }
    
    // MARK: Archives
    /// a GNU zip archive (.gz)
    /// @note: Introduced in 10.10 and soft-backported
    public static var Gzip:        UTI { return UTI("org.gnu.gnu-zip-archive") }
    /// a bzip2 archive (.bz2)
    /// @note: Introduced in 10.10 and soft-backported
    public static var Bzip:        UTI { return UTI("public.bzip2-archive") }
    /// a zip archive (.zip)
    /// @note: Introduced in 10.10 and soft-backported
    public static var Zip:         UTI { return UTI("public.zip-archive") }
    /// a Java archive (.jar)
    /// @note: Introduced in 10.10 and soft-backported
    public static var JavaArchive: UTI { return UTI("com.sun.java-archive") }
    /// a XAR archive (.xar)
    public static var XAR:         UTI { return UTI("com.apple.xar-archive") }
    /// a Stuff-It archive (.sit)
    public static var StuffIt:     UTI { return UTI("com.allume.stuffit-archive") }
    /// a XZ archive (.xz)
    public static var XZ:          UTI { return UTI("org.tukaani.xz-archive") }
    /// a LZMA archive (.lz)
    public static var LZMA:        UTI { return UTI("org.tukaani.lzma-archive") }
    /// a Debian package (.deb)
    public static var Debian:      UTI { return UTI("org.debian.deb-archive") }
    /// a Red Hat package (.rpm)
    public static var RedHat:      UTI { return UTI("com.redhat.rpm-archive") }
    /// a Windows Installer cabinet (.cab)
    public static var WindowsCAB:  UTI { return UTI("com.microsoft.cab-archive") }
    /// a 7-Zip archive (.7z)
    public static var SevenZip:    UTI { return UTI("org.7-zip.7-zip-archive") }
    /// a RAR archive (.rar)
    public static var RAR:         UTI { return UTI("com.rarlab.rar-archive") }

    // MARK: Documents
    /// base spreadsheet document type
    /// @note: Introduced in 10.10 and soft-backported
    public static var Spreadsheet:  UTI { return UTI("public.spreadsheet") }
    /// base presentation document type
    /// @note: Introduced in 10.10 and soft-backported
    public static var Presentation: UTI { return UTI("public.presentation") }
    /// a database store
    public static var Database:     UTI { return UTI(kUTTypeDatabase) }
    /// legacy Microsoft Word word-processing document .(doc)
    public static var Word:         UTI { return UTI("com.microsoft.word.doc") }
    /// Microsoft Word word-processing document (.docx)
    public static var WordX:        UTI { return UTI("com.microsoft.word.openxml.document") }
    /// Legacy Microsoft PowerPoint presentation (.ppt)
    public static var PowerPoint:   UTI { return UTI("com.microsoft.powerpoint.ppt") }
    /// Microsoft PowerPoint presentation (.pptx)
    public static var PowerPointX:  UTI { return UTI("com.microsoft.powerpoint.openxml.presentation") }
    /// Legacy Microsoft Excel spreadsheet (.xls)
    public static var Excel:        UTI { return UTI("com.microsoft.excel.xls") }
    /// Microsoft Excel spreadsheet (.xlsx)
    public static var ExcelX:       UTI { return UTI("com.microsoft.excel.openxml.workbook") }
    /// Apple Pages word-processing document (.pages)
    public static var Pages:        UTI { return UTI("com.apple.iwork.pages.pages") }
    /// Apple Keynote presentation (.key)
    public static var Keynote:      UTI { return UTI("com.apple.iWork.Keynote.key") }
    /// Apple Numbers spreadsheet (.numbers)
    public static var Numbers:      UTI { return UTI("com.apple.iWork.Numbers.numbers") }
    
    // MARK: Mail
    /// VCard format (.vcard, .vcf)
    public static var VCard:         UTI { return UTI(kUTTypeVCard) }
    /// to-do item
    /// @note: Introduced in 10.10 and soft-backported
    public static var ToDo:          UTI { return UTI("public.to-do-item") }
    /// calendar event (.ical, .ics)
    /// @note: Introduced in 10.10 and soft-backported
    public static var CalendarEvent: UTI { return UTI("public.calendar-event") }
    /// e-mail message (.eml)
    /// @note: Introduced in 10.10 and soft-backported
    public static var Mail:          UTI { return UTI("public.email-message") }
    
    // MARK: Internet
    /// base type for Apple Internet locations
    /// @note: Introduced in 10.10 and soft-backported
    public static var InternetLocation: UTI { return UTI("com.apple.internet-location") }
    /// bookmark
    /// @note: Introduced in 10.10 and soft-backported
    public static var Bookmark:         UTI { return UTI("public.bookmark") }
    /// WebKit bookmark document (.webbookmark)
    public static var SafariBookmark:   UTI { return UTI("com.apple.safari.bookmark") }
    /// UTF-8 string indicating the title for an attached URL
    /// @see UTI.URL
    public static var URLName:          UTI { return UTI("public.url-name") }
    /// Rich Site Summary XML format (.rss)
    public static var RSS:              UTI { return UTI("public.rss") }
    /// BitTorrent announcement file (.torrent)
    public static var Torrent:          UTI { return UTI("com.bittorrent.torrent") }
    /// Software extension for Safari (.safariextz)
    public static var SafariExtension:  UTI { return UTI("com.apple.safari.extension") }
    /// Software extension for Google Chrome (.crx)
    public static var ChromeExtension:  UTI { return UTI("org.chromium.extension") }
    /// Cascading Style-Sheet for HTML (.css)
    public static var CSS:              UTI { return UTI("org.w3.css") }
    
    // MARK: Miscellaneous
    /// Opaque InkText data
    public static var InkText:     UTI { return UTI(kUTTypeInkText) }
    /// base type for fonts
    /// @note: Introduced in 10.10 and soft-backported
    public static var Font:        UTI { return UTI("public.font") }
    /// base type for 3D content
    /// @note: Introduced in 10.10 and soft-backported
    public static var ThreeD:      UTI { return UTI("public.3d-content") }
    /// PKCS#12 format (.p12)
    /// @note: Introduced in 10.10 and soft-backported
    public static var PKCS12:      UTI { return UTI("com.rsa.pkcs-12") }
    /// X.509 certificate format (.cer)
    /// @note: Introduced in 10.10 and soft-backported
    public static var Certificate: UTI { return UTI("public.x509-certificate") }
    /// ePub format (.epub)
    /// @note: Introduced in 10.10 and soft-backported
    public static var EPub:        UTI { return UTI("org.idpf.epub-container") }
    /// console log (.log)
    /// @note: Introduced in 10.10 and soft-backported
    public static var Log:         UTI { return UTI("public.log") }
    
}
