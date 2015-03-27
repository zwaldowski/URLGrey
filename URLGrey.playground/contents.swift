// Playground - noun: a place where people can play

import URLGrey

let url = NSURL(fileURLWithPath: "/System/Library/CoreServices/SystemVersion.plist", isDirectory: false)!
let uti = url.value(forResource: Resource.TypeIdentifier).value
let myUTI = UTI(preferredTag: .FilenameExtension("plist"))
