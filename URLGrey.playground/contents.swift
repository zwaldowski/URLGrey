// Playground - noun: a place where people can play

import URLGrey
import XCPlayground

let fm = NSFileManager()
let sysLib = try! fm.URLForDirectory(.LibraryDirectory, inDomain: .SystemDomainMask, appropriateForURL: nil, create: false)
let coreSvcs = sysLib + .Directory("CoreServices")
let sysVersion = coreSvcs + .File("SystemVersion", .PropertyList)

let uti = try! sysVersion.valueForResource(URLResource.TypeIdentifier)
let myUTI = UTI(preferredTag: .FilenameExtension("plist"))

for url in coreSvcs.contents(fetchResources: [ URLResource.TypeIdentifier ], options: .SkipsSubdirectoryDescendants) {
    print(url)
}

for i in sysVersion.ancestors {
    print(i)
}

let gen = try! sysVersion.valueForResource(URLResource.GenerationIdentifier)
