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
    
    public struct Public {
        public static var Item:             UTI { return UTI(kUTTypeItem) }
        public static var Content:          UTI { return UTI(kUTTypeContent) }
        public static var CompositeContent: UTI { return UTI(kUTTypeCompositeContent) }
        public static var Message:          UTI { return UTI(kUTTypeMessage) }
        public static var Contact:          UTI { return UTI(kUTTypeContact) }
        public static var DiskImage:        UTI { return UTI(kUTTypeDiskImage) }
    }
    
    public struct Base {
        public static var Data:         UTI { return UTI(kUTTypeData) }
        public static var Directory:    UTI { return UTI(kUTTypeDirectory) }
        public static var Resolvable:   UTI { return UTI(kUTTypeResolvable) }
        public static var SymbolicLink: UTI { return UTI(kUTTypeSymLink) }
        public static var Executable:   UTI { return UTI(kUTTypeExecutable) }
        public static var MountPoint:   UTI { return UTI(kUTTypeMountPoint) }
        public static var AliasFile:    UTI { return UTI(kUTTypeAliasFile) }
        public static var AliasRecord:  UTI { return UTI(kUTTypeAliasRecord) }
        public static var URLBookmark:  UTI { return UTI(kUTTypeURLBookmarkData) }
    }
    
    public struct Cocoa {
        public static var URL:                     UTI { return UTI(kUTTypeURL) }
        public static var FileURL:                 UTI { return UTI(kUTTypeFileURL) }
        public static var PromisedFileURL:         UTI { return UTI("com.apple.pasteboard.promised-file-url") }
        public static var PromisedFileContentType: UTI { return UTI("com.apple.pasteboard.promised-file-content-type") }
    }
    
    public struct Text {
        public static var Base:               UTI { return UTI(kUTTypeText) }
        public static var Plain:              UTI { return UTI(kUTTypePlainText) }
        public static var PlainUTF8:          UTI { return UTI(kUTTypeUTF8PlainText) }
        public static var ExternalPlainUTF16: UTI { return UTI(kUTTypeUTF16ExternalPlainText) }
        public static var PlainUTF16:         UTI { return UTI(kUTTypeUTF16PlainText) }
        public static var Delimited:          UTI { return UTI(kUTTypeDelimitedText) }
        public static var CommaSeparated:     UTI { return UTI(kUTTypeCommaSeparatedText) }
        public static var TabSeparated:       UTI { return UTI(kUTTypeTabSeparatedText) }
        public static var TabSeparatedUTF8:   UTI { return UTI(kUTTypeUTF8TabSeparatedText) }
        public static var Rich:               UTI { return UTI(kUTTypeRTF) }
        public static var ReStructuredText:   UTI { return UTI("org.python.restructuredtext") }
    }
    
    public struct Markup {
        public static var HTML:     UTI { return UTI(kUTTypeHTML) }
        public static var XML:      UTI { return UTI(kUTTypeXML) }
        public static var TeX:      UTI { return UTI("org.tug.tex") }
        public static var XSL:      UTI { return UTI("org.w3.xsl") }
        public static var Markdown: UTI { return UTI("net.daringfireball.markdown") }
    }
    
    public struct Source {
        public static var Code:     UTI { return UTI(kUTTypeSourceCode) }
        public static var Assembly:  UTI { return UTI(kUTTypeAssemblyLanguageSource) }
        public static var C:         UTI { return UTI(kUTTypeCSource) }
        public static var ObjC:      UTI { return UTI(kUTTypeObjectiveCSource) }
        public static var CPP:       UTI { return UTI(kUTTypeCPlusPlusSource) }
        public static var ObjCPP:    UTI { return UTI(kUTTypeObjectiveCPlusPlusSource) }
        public static var CHeader:   UTI { return UTI(kUTTypeCHeader) }
        public static var CPPHeader: UTI { return UTI(kUTTypeCPlusPlusHeader) }
        public static var Java:      UTI { return UTI(kUTTypeJavaSource) }
        public static var Swift:     UTI { return UTI("public.swift-source") }
        public static var CSharp:    UTI { return UTI("com.microsoft.csharp-source") }
        public static var Groovy:    UTI { return UTI("org.codehaus.groovy-source") }
        public static var Erlang:    UTI { return UTI("org.erlang.erlang-source") }
        public static var Haskell:   UTI { return UTI("org.haskell.haskell-source") }
    }
    
    public struct Script {
        public static var Base:         UTI { return UTI(kUTTypeScript) }
        public static var Shell:        UTI { return UTI("public.shell-script") }
        public static var AppleScript:  UTI { return UTI(kUTTypeAppleScript) }
        public static var OSABinary:    UTI { return UTI(kUTTypeOSAScript) }
        public static var OSABundly:    UTI { return UTI(kUTTypeOSAScriptBundle) }
        public static var JavaScript:   UTI { return UTI(kUTTypeJavaScript) }
        public static var Delimited:    UTI { return UTI(kUTTypeShellScript) }
        public static var Perl:         UTI { return UTI(kUTTypePerlScript) }
        public static var Python:       UTI { return UTI(kUTTypePythonScript) }
        public static var Ruby:         UTI { return UTI(kUTTypeRubyScript) }
        public static var PHP:          UTI { return UTI(kUTTypePHPScript) }
        public static var ASP:          UTI { return UTI("com.microsoft.asp") }
        public static var VisualBasic:  UTI { return UTI("com.microsoft.vb-source") }
        public static var CoffeeScript: UTI { return UTI("org.coffeescript.coffeescript") }
        public static var Lua:          UTI { return UTI("org.lua.lua-source") }
        public static var OCaml:        UTI { return UTI("org.ocaml.ocaml-source") }
        public static var Scala:        UTI { return UTI("org.scala-lang.scala") }
        public static var Swig:         UTI { return UTI("org.swig.swig") }
    }
    
    public struct Serialized {
        public static var JSON:               UTI { return UTI(kUTTypeJSON) }
        public static var PropertyList:       UTI { return UTI(kUTTypePropertyList) }
        public static var PropertyListXML:    UTI { return UTI(kUTTypeXMLPropertyList) }
        public static var PropertyListBinary: UTI { return UTI(kUTTypeBinaryPropertyList) }
        public static var YAML:               UTI { return UTI("org.yaml.yaml") }
        public static var OPML:               UTI { return UTI("org.opml.opml") }
    }
    
    public struct Composite {
        public static var PDF:        UTI { return UTI(kUTTypePDF) }
        public static var RTFD:       UTI { return UTI(kUTTypeRTFD) }
        public static var RTFDFlat:   UTI { return UTI(kUTTypeFlatRTFD) }
        public static var Textension: UTI { return UTI(kUTTypeTXNTextAndMultimediaData) }
        public static var WebArchive: UTI { return UTI(kUTTypeWebArchive) }
        public static var PostScript: UTI { return UTI("com.adobe.postscript") }
    }
    
    public struct Graphic {
        public static var Image:          UTI { return UTI(kUTTypeImage) }
        public static var JPEG:           UTI { return UTI(kUTTypeJPEG) }
        public static var JPEG2000:       UTI { return UTI(kUTTypeJPEG2000) }
        public static var TIFF:           UTI { return UTI(kUTTypeTIFF) }
        public static var PICT:           UTI { return UTI(kUTTypePICT) }
        public static var GIF:            UTI { return UTI(kUTTypeGIF) }
        public static var PNG:            UTI { return UTI(kUTTypePNG) }
        public static var QuickTime:      UTI { return UTI(kUTTypeQuickTimeImage) }
        public static var Icon:           UTI { return UTI(kUTTypeAppleICNS) }
        public static var WindowsBitmap:  UTI { return UTI(kUTTypeBMP) }
        public static var WindowsIcon:    UTI { return UTI(kUTTypeICO) }
        public static var Raw:            UTI { return UTI(kUTTypeRawImage) }
        public static var ScalableVector: UTI { return UTI(kUTTypeScalableVectorGraphics) }
        public static var WebP:           UTI { return UTI("com.google.webp") }
        public static var Photoshop:      UTI { return UTI("com.adobe.photoshop-image") }
    }
    
    public struct Media {
        public static var Content:      UTI { return UTI(kUTTypeAudiovisualContent) }
        public static var Movie:        UTI { return UTI(kUTTypeMovie) }
        public static var Video:        UTI { return UTI(kUTTypeVideo) }
        public static var Audio:        UTI { return UTI(kUTTypeAudio) }
        public static var QuickTime:    UTI { return UTI(kUTTypeQuickTimeMovie) }
        public static var MPEG:         UTI { return UTI(kUTTypeMPEG) }
        public static var MP2:          UTI { return UTI(kUTTypeMPEG2Video) }
        public static var MP2TS:        UTI { return UTI(kUTTypeMPEG2TransportStream) }
        public static var MP3:          UTI { return UTI(kUTTypeMP3) }
        public static var MP4:          UTI { return UTI(kUTTypeMPEG4) }
        public static var M4A:          UTI { return UTI(kUTTypeMPEG4Audio) }
        public static var M4AProtected: UTI { return UTI(kUTTypeAppleProtectedMPEG4Audio) }
        public static var M4VProtected: UTI { return UTI(kUTTypeAppleProtectedMPEG4Video) }
        public static var AVI:          UTI { return UTI(kUTTypeAVIMovie) }
        public static var AIFF:         UTI { return UTI(kUTTypeAudioInterchangeFileFormat) }
        public static var WAV:          UTI { return UTI(kUTTypeWaveformAudio) }
        public static var MIDI:         UTI { return UTI(kUTTypeMIDIAudio) }
        public static var Playlist:     UTI { return UTI(kUTTypePlaylist) }
        public static var PlaylistM3U:  UTI { return UTI(kUTTypeM3UPlaylist) }
    }
    
    public struct Directory {
        public static var Folder:    UTI { return UTI(kUTTypeFolder) }
        public static var Volume:    UTI { return UTI(kUTTypeVolume) }
        public static var Package:   UTI { return UTI(kUTTypePackage) }
        public static var Bundle:    UTI { return UTI(kUTTypeBundle) }
        public static var Plugin:    UTI { return UTI(kUTTypePluginBundle) }
        public static var Spotlight: UTI { return UTI(kUTTypeSpotlightImporter) }
        public static var QuickLook: UTI { return UTI(kUTTypeQuickLookGenerator) }
        public static var XPC:       UTI { return UTI(kUTTypeXPCService) }
        public static var Framework: UTI { return UTI(kUTTypeFramework) }
    }
    
    public struct Application {
        public static var Executable:     UTI { return UTI(kUTTypeApplication) }
        public static var Bundle:         UTI { return UTI(kUTTypeApplicationBundle) }
        public static var Classic:        UTI { return UTI(kUTTypeApplicationFile) }
        public static var Unix:           UTI { return UTI(kUTTypeUnixExecutable) }
        public static var Windows:        UTI { return UTI(kUTTypeWindowsExecutable) }
        public static var Java:           UTI { return UTI(kUTTypeJavaClass) }
        public static var PreferencePane: UTI { return UTI(kUTTypeSystemPreferencesPane) }
    }
    
    public struct Archive {
        public static var Base:     UTI { return UTI(kUTTypeArchive) }
        public static var Gzip:     UTI { return UTI(kUTTypeGNUZipArchive) }
        public static var Bzip:     UTI { return UTI(kUTTypeBzip2Archive) }
        public static var Zip:      UTI { return UTI(kUTTypeZipArchive) }
        public static var Java:     UTI { return UTI(kUTTypeJavaArchive) }
        public static var XAR:      UTI { return UTI("com.apple.xar-archive") }
        public static var StuffIt:  UTI { return UTI("com.allume.stuffit-archive") }
        public static var XZ:       UTI { return UTI("org.tukaani.xz-archive") }
        public static var LZMA:     UTI { return UTI("org.tukaani.lzma-archive") }
        public static var Debian:   UTI { return UTI("org.debian.deb-archive") }
        public static var RedHat:   UTI { return UTI("com.redhat.rpm-archive") }
        public static var Windows:  UTI { return UTI("com.microsoft.cab-archive") }
        public static var SevenZip: UTI { return UTI("org.7-zip.7-zip-archive") }
        public static var RAR:      UTI { return UTI("com.rarlab.rar-archive") }
    }
    
    public struct Document {
        public static var Spreadsheet:  UTI { return UTI(kUTTypeSpreadsheet) }
        public static var Presentation: UTI { return UTI(kUTTypePresentation) }
        public static var Database:     UTI { return UTI(kUTTypeDatabase) }
        
        public struct Office {
            public static var Word:        UTI { return UTI("com.microsoft.word.doc") }
            public static var WordX:       UTI { return UTI("com.microsoft.word.openxml.document") }
            public static var PowerPoint:  UTI { return UTI("com.microsoft.powerpoint.ppt") }
            public static var PowerPointX: UTI { return UTI("com.microsoft.powerpoint.openxml.presentation") }
            public static var Excel:       UTI { return UTI("com.microsoft.excel.xls") }
            public static var ExcelX:      UTI { return UTI("com.microsoft.excel.openxml.workbook") }
        }
        
        public struct iWork {
            public static var Pages:   UTI { return UTI("com.apple.iwork.pages.pages") }
            public static var Keynote: UTI { return UTI("com.apple.iWork.Keynote.key") }
            public static var Numbers: UTI { return UTI("com.apple.iWork.Numbers.numbers") }
        }
        
        public struct OpenOffice {
            public static var Formula:      UTI { return UTI("org.openoffice.formula") }
            public static var Graphics:     UTI { return UTI("org.openoffice.graphics") }
            public static var Presentation: UTI { return UTI("org.openoffice.presentation") }
            public static var Spreadsheet:  UTI { return UTI("org.openoffice.spreadsheet") }
            public static var Text:         UTI { return UTI("org.openoffice.text") }
        }
    }
    
    public struct Mail {
        public static var VCard:         UTI { return UTI(kUTTypeVCard) }
        public static var ToDo:          UTI { return UTI(kUTTypeToDoItem) }
        public static var CalendarEvent: UTI { return UTI(kUTTypeCalendarEvent) }
        public static var Message:       UTI { return UTI(kUTTypeEmailMessage) }
    }
    
    public struct Miscellaneous {
        public static var InkText:     UTI { return UTI(kUTTypeInkText) }
        public static var Font:        UTI { return UTI(kUTTypeFont) }
        public static var ThreeD:      UTI { return UTI(kUTType3DContent) }
        public static var PKCS12:      UTI { return UTI(kUTTypePKCS12) }
        public static var Certificate: UTI { return UTI(kUTTypeX509Certificate) }
        public static var EPub:        UTI { return UTI(kUTTypeElectronicPublication) }
        public static var Log:         UTI { return UTI(kUTTypeLog) }
    }
    
    public struct Internet {
        public static var Location:        UTI { return UTI(kUTTypeInternetLocation) }
        public static var Bookmark:        UTI { return UTI(kUTTypeBookmark) }
        public static var SafariBookmark:  UTI { return UTI("com.apple.safari.bookmark") }
        public static var URLName:         UTI { return UTI("public.url-name") }
        public static var RSS:             UTI { return UTI("public.rss") }
        public static var Torrent:         UTI { return UTI("com.bittorrent.torrent") }
        public static var SafariExtension: UTI { return UTI("com.apple.safari.extension") }
        public static var ChromeExtension: UTI { return UTI("org.chromium.extension") }
        public static var CSS:             UTI { return UTI("org.w3.css") }
    }
    
}
