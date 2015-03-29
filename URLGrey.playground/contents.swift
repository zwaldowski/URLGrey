// Playground - noun: a place where people can play

import URLGrey
import XCPlayground

let coreSvcs = NSURL(fileURLWithPath: "/System/Library/CoreServices", isDirectory: true)!
let sysVersion = coreSvcs + .File("SystemVersion", .PropertyList)

let uti = sysVersion.value(forResource: Resource.TypeIdentifier).value
let myUTI = UTI(preferredTag: .FilenameExtension("plist"))

for url in coreSvcs.contents(fetchedResources: [ Resource.TypeIdentifier ], options: .SkipsSubdirectoryDescendants) {
    println(url)
}

