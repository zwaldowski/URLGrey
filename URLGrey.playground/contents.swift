// Playground - noun: a place where people can play

import URLGrey

let url2 = NSURL(fileURLWithPath: "/System/Library/CoreServices", isDirectory: true)!
let url = NSURL(fileURLWithPath: "/System/Library/CoreServices/SystemVersion.plist", isDirectory: false)!
let uti = url.value(forResource: Resource.TypeIdentifier).value
let myUTI = UTI(preferredTag: .FilenameExtension("plist"))

let fm = NSFileManager()

for i in fm.directory(URL: url2, fetchResources: [ Resource.TypeIdentifier ], options: .SkipsSubdirectoryDescendants) {
    println(i)
}
