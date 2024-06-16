
# Control Kit

Control & monitor your mac using swift code.

```swift
try await Keyboard.press("hello", modifiers: .shift)
```


## Getting Started

`ControlKit` uses [Swift Package Manager](https://www.swift.org/documentation/package-manager/) as its build tool. If you want to import in your own project, it's as simple as adding a `dependencies` clause to your `Package.swift`:
```swift
dependencies: [
    .package(url: "https://github.com/Vaida12345/ControlKit.git", branch: "main")
]
```
and then adding the appropriate module to your target dependencies.

### Using Xcode Package support

You can add this framework as a dependency to your Xcode project by clicking File -> Swift Packages -> Add Package Dependency. The package is located at:
```
https://github.com/Vaida12345/ControlKit
```
## Documentation

The documentation is included in the package as DocC.
<img width="1587" alt="DocC" src="https://github.com/Vaida12345/ControlKit/assets/91354917/501460f4-2cc6-4207-be8a-151b76d23e73">

