# pearOs
api for pearos.xyz website. pearOS is a free, open-source Linux distribution with a Mac-inspired desktop — a real menu bar, dock, and app store, built on Arch Linux, Debian
# main
```swift
import Foundation
import pearOs

let pear = PearOsSite()
let versionsList = try await pear.getVersions(nameVersion: "nicecore-versions")
print(versionsList)
```

# Launch (your script)
```
swift run
```
