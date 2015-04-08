// Playground - noun: a place where people can play

import URLGrey
import Lustre
import XCPlayground

let fm = NSFileManager()
let sysLib = fm.URLForDirectory(.LibraryDirectory, inDomain: .SystemDomainMask, appropriateForURL: nil, create: false, error: nil)!
let coreSvcs = sysLib + .Directory("CoreServices")
let sysVersion = coreSvcs + .File("SystemVersion", .PropertyList)

let uti = sysVersion.value(forResource: .TypeIdentifier).value
let myUTI = UTI(preferredTag: .FilenameExtension("plist"))

for url in coreSvcs.contents(fetchedResources: [ .TypeIdentifier ], options: .SkipsSubdirectoryDescendants) {
    println(url)
}

for i in sysVersion.ancestors {
    println(i)
}

let gen = sysVersion.value(forResource: .GenerationIdentifier).value
