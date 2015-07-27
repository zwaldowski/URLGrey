//
//  UTI+CoreTypes.swift
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
    public static var URLBookmark:  UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("com.apple.bookmark")
            }
        #endif
        return UTI(kUTTypeBookmark)
    }

    // MARK: Cocoa
    /// The bytes of a URL
    public static var URL:                     UTI { return UTI(kUTTypeURL) }
    /// The text of a "file:" URL
    public static var FileURL:                 UTI { return UTI(kUTTypeFileURL) }
    /// a file url on the pasteboard to a file which does not yet exist
    @available(OSX 10.6, *)
    @available(iOS, unavailable)
    @available(watchOS, unavailable)
    public static var PromisedFileURL:         UTI { return UTI("com.apple.pasteboard.promised-file-url") }
    /// a UTI string describing the type of data to be contained within the promised file
    @available(OSX 10.6, *)
    @available(iOS, unavailable)
    @available(watchOS, unavailable)
    public static var PromisedFileContentType: UTI { return UTI("com.apple.pasteboard.promised-file-content-type") }
    
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
    public static var Delimited:          UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("public.delimited-values-text")
            }
        #endif
        return UTI(kUTTypeDelimitedText)
    }
    /// text containing comma-separated values (.csv)
    public static var CommaSeparated:     UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("public.comma-separated-values-text")
            }
        #endif
        return UTI(kUTTypeCommaSeparatedText)
    }
    /// text containing tab-separated values
    public static var TabSeparated:       UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("public.tab-separated-values-text")
            }
        #endif
        return UTI(kUTTypeTabSeparatedText)
    }
    /// UTF-8 encoded text containing tab-separated values
    public static var TabSeparatedUTF8:   UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("public.utf8-tab-separated-values-text")
            }
        #endif
        return UTI(kUTTypeUTF8TabSeparatedText)
    }
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
    public static var Assembly:   UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("public.assembly-source")
            }
        #endif
        return UTI(kUTTypeAssemblyLanguageSource)
    }
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
    public static var Swift:      UTI {
        guard #available(OSX 10.11, iOS 9.0, watchOS 2.0, *) else {
            return UTI("public.swift-source")
        }
        return UTI(kUTTypeSwiftSource)
    }
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
    public static var Script:       UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("public.script")
            }
        #endif
        return UTI(kUTTypeScript)
    }
    /// AppleScript text format (.applescript)
    public static var AppleScript:  UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("com.apple.applescript.text")
            }
        #endif
        return UTI(kUTTypeAppleScript)
    }
    /// Open Scripting Architecture script binary format (.scpt)
    public static var OSABinary:    UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("com.apple.applescript.script")
            }
        #endif
        return UTI(kUTTypeOSAScript)
    }
    /// Open Scripting Architecture script bundle format (.scptd)
    public static var OSABundle:    UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("com.apple.applescript.script-bundle")
            }
        #endif
        return UTI(kUTTypeOSAScriptBundle)
    }
    /// JavaScript source code (.js)
    public static var JavaScript:   UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("com.netscape.javascript-source")
            }
        #endif
        return UTI(kUTTypeJavaScript)
    }
    /// base type for shell scripts (.sh)
    public static var Shell:        UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("public.shell-script")
            }
        #endif
        return UTI(kUTTypeShellScript)
    }
    /// Perl script (.pl)
    public static var Perl:         UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("public.perl-script")
            }
        #endif
        return UTI(kUTTypePerlScript)
    }
    /// Python script (.py)
    public static var Python:       UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("public.python-script")
            }
        #endif
        return UTI(kUTTypePythonScript)
    }
    /// Ruby script (.rb)
    public static var Ruby:         UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("public.ruby-script")
            }
        #endif
        return UTI(kUTTypeRubyScript)
    }
    /// PHP script (.php)
    public static var PHP:          UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("public.php-script")
            }
        #endif
        return UTI(kUTTypePHPScript)
    }
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
    public static var JSON:               UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("public.json")
            }
        #endif
        return UTI(kUTTypeJSON)
    }
    /// base type for property lists (.plist)
    public static var PropertyList:       UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("com.apple.property-list")
            }
        #endif
        return UTI(kUTTypePropertyList)
    }
    /// XML property list
    public static var PropertyListXML:    UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("com.apple.xml-property-list")
            }
        #endif
        return UTI(kUTTypeXMLPropertyList)
    }
    /// Binary property list
    public static var PropertyListBinary: UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("com.apple.binary-property-list")
            }
        #endif
        return UTI(kUTTypeBinaryPropertyList)
    }
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
    public static var Raw:            UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("public.camera-raw-image")
            }
        #endif
        return UTI(kUTTypeRawImage)
    }
    /// SVG image (.svg)
    public static var ScalableVector: UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("public.svg-image")
            }
        #endif
        return UTI(kUTTypeScalableVectorGraphics)
    }
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
    public static var MPEG:         UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("public.mpeg")
            }
        #endif
        return UTI(kUTTypeMPEG)
    }
    /// MPEG-2 video (.mp2)
    public static var MP2:          UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("public.mpeg-2-video")
            }
        #endif
        return UTI(kUTTypeMPEG2Video)
    }
    /// MPEG-2 Transport Stream movie format (.ts, .m2ts)
    public static var MP2TS:        UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("public.mpeg-2-transport-stream")
            }
        #endif
        return UTI(kUTTypeMPEG2TransportStream)
    }
    /// MPEG-3 audio (.mp3)
    public static var MP3:          UTI { return UTI(kUTTypeMP3) }
    /// MPEG-4 movie (.mp4)
    public static var MP4:          UTI { return UTI(kUTTypeMPEG4) }
    /// MPEG-4 audio layer (.m4a)
    public static var M4A:          UTI { return UTI(kUTTypeMPEG4Audio) }
    /// Apple protected iTunes music store format (.m4p)
    public static var M4AProtected: UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("com.apple.protected-mpeg-4-audio")
            }
        #endif
        return UTI(kUTTypeAppleProtectedMPEG4Audio)
    }
    /// Apple protected MPEG-4 movie (.m4v)
    public static var M4VProtected: UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("com.apple.protected-mpeg-4-video")
            }
        #endif
        return UTI(kUTTypeAppleProtectedMPEG4Video)
    }
    /// Audio Video Interleaved movie format (.avi)
    public static var AVI:          UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("public.avi")
            }
        #endif
        return UTI(kUTTypeAVIMovie)
    }
    /// AIFF audio format (.aiff, .aif)
    public static var AIFF:         UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("public.aiff-audio")
            }
        #endif
        return UTI(kUTTypeAudioInterchangeFileFormat)
    }
    /// Waveform audio format (.wav)
    public static var WAV:          UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("com.microsoft.waveform-audio")
            }
        #endif
        return UTI(kUTTypeWaveformAudio)
    }
    /// MIDI audio format (.mid)
    public static var MIDI:         UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("public.midi-audio")
            }
        #endif
        return UTI(kUTTypeMIDIAudio)
    }
    /// base type for playlists
    public static var Playlist:     UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("public.playlist")
            }
        #endif
        return UTI(kUTTypePlaylist)
    }
    /// M3U or M3U8 playlist (.m3u, .m3u8)
    public static var PlaylistM3U:  UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("public.m3u-playlist")
            }
        #endif
        return UTI(kUTTypeM3UPlaylist)
    }
    
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
    public static var Plugin:    UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("com.apple.plugin")
            }
        #endif
        return UTI(kUTTypePluginBundle)
    }
    /// a Spotlight metadata importer (.mdimporter)
    public static var Spotlight: UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("com.apple.metadata-importer")
            }
        #endif
        return UTI(kUTTypeSpotlightImporter)
    }
    /// a QuickLook preview generator (.qlgenerator)
    public static var QuickLook: UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("com.apple.quicklook-generator")
            }
        #endif
        return UTI(kUTTypeQuickLookGenerator)
    }
    /// an XPC service (.xpc)
    public static var XPC:       UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("com.apple.xpc-service")
            }
        #endif
        return UTI(kUTTypeXPCService)
    }
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
    public static var AppUnix:        UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("public.unix-executable")
            }
        #endif
        return UTI(kUTTypeUnixExecutable)
    }
    /// a Windows executable (.exe)
    public static var AppWindows:     UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("com.microsoft.windows-executable")
            }
        #endif
        return UTI(kUTTypeWindowsExecutable)
    }
    /// a Java class (.class)
    public static var JavaClass:      UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("com.sun.java-class")
            }
        #endif
        return UTI(kUTTypeJavaClass)
    }
    /// a System Preferences pane (.prefpane)
    public static var PreferencePane: UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("com.apple.systempreference.prefpane")
            }
        #endif
        return UTI(kUTTypeSystemPreferencesPane)
    }
    
    // MARK: Archives
    /// a GNU zip archive (.gz)
    public static var Gzip:        UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("org.gnu.gnu-zip-archive")
            }
        #endif
        return UTI(kUTTypeGNUZipArchive)
    }
    /// a bzip2 archive (.bz2)
    public static var Bzip:        UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("public.bzip2-archive")
            }
        #endif
        return UTI(kUTTypeBzip2Archive)
    }
    /// a zip archive (.zip)
    public static var Zip:         UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("public.zip-archive")
            }
        #endif
        return UTI(kUTTypeZipArchive)
    }
    /// a Java archive (.jar)
    public static var JavaArchive: UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("com.sun.java-archive")
            }
        #endif
        return UTI(kUTTypeJavaArchive)
    }
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
    public static var Spreadsheet:  UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("public.spreadsheet")
            }
        #endif
        return UTI(kUTTypeSpreadsheet)
    }
    /// base presentation document type
    public static var Presentation: UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("public.presentation")
            }
        #endif
        return UTI(kUTTypePresentation)
    }
    /// a database store
    public static var Database:     UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("public.database")
            }
        #endif
        return UTI(kUTTypeExecutable)
    }
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
    public static var ToDo:          UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("public.to-do-item")
            }
        #endif
        return UTI(kUTTypeToDoItem)
    }
    /// calendar event (.ical, .ics)
    public static var CalendarEvent: UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("public.calendar-event")
            }
        #endif
        return UTI(kUTTypeCalendarEvent)
    }
    /// e-mail message (.eml)
    public static var Mail:          UTI  {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("public.email-message")
            }
        #endif
        return UTI(kUTTypeEmailMessage)
    }
    
    // MARK: Internet
    /// base type for Apple Internet locations
    public static var InternetLocation: UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("com.apple.internet-location")
            }
        #endif
        return UTI(kUTTypeInternetLocation)
    }
    /// bookmark
    public static var Bookmark:         UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("public.bookmark")
            }
        #endif
        return UTI(kUTTypeBookmark)
    }
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
    public static var Font:        UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("public.font")
            }
        #endif
        return UTI(kUTTypeFont)
    }
    /// base type for 3D content
    public static var ThreeD:      UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("public.3d-content")
            }
        #endif
        return UTI(kUTType3DContent)
    }
    /// PKCS#12 format (.p12)
    public static var PKCS12:      UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("com.rsa.pkcs-12")
            }
        #endif
        return UTI(kUTTypePKCS12)
    }
    /// X.509 certificate format (.cer)
    public static var Certificate: UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("public.x509-certificate")
            }
        #endif
        return UTI(kUTTypeX509Certificate)
    }
    /// ePub format (.epub)
    public static var EPub:        UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("org.idpf.epub-container")
            }
        #endif
        return UTI(kUTTypeElectronicPublication)
    }
    /// console log (.log)
    public static var Log:         UTI {
        #if os(OSX)
            guard #available(OSX 10.10, *) else {
                return UTI("public.log")
            }
        #endif
        return UTI(kUTTypeLog)
    }
    
}
