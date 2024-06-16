# ``ControlKit``

Control & monitor your mac using swift code.

@Metadata {
    @PageColor(purple)
    
    @SupportedLanguage(swift)
    
    @Available(macOS, introduced: 13.0)
}

## Overview

This package includes a list of functions to control and monitor your mac via `CoreGraphics`.

### The Abstractions

@Links(visualStyle: compactGrid) {
    - ``Keyboard``
    - ``Mouse``
    - ``Screen``
}

All of these structures provides `static` functions to interact.

@TabNavigator {
    @Tab("Keyboard") {
        This would use the keyboard to type "HELLO" in capital. (Because of the `shift` modifier)
        
        ```swift
        try await Keyboard.press("hello", modifiers: .shift)
        ```
    }
    
    
    @Tab("Mouse") {
        This would move the cursor to the 100px and 100px position to the top left of the screen
        
        ```swift
        Mouse.tap(at: CGPoint(x: 100, y: 100))
        ```
    }
    
    
    @Tab("Screen") {
        This would capture every window of Finder and save it into a desktop folder.
        
        ```swift
        let windows = try Screen.windows()
        
        for window in windows.filter({ $0.owner.name == "Finder" }) {
            let image = Screen.capture(window)
            try image?.write(to: .desktopDirectory.appending(path: "Captures/\(window.description).png"))
        }
        ```
    }
    
    @Tab("Window") {
        This would move the first window of safari that opens ChatGPT, and moves it to the top left corner.
        
        ```swift
        let windows = try Screen.windows().first { $0.owner.name == "Safari" && $0.name!.contains("ChatGPT") }!
        try windows.control.move(to: .zero)
        ```
    }
}


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

## Topics

### Abstractions

- ``Keyboard``
- ``Mouse``
- ``Screen``

### Windows Controls

- ``ApplicationServices/AXUIElement``

### Working with Terminal 

- ``execute(_:)``

### Imported from GraphicsKit

- ``NativeImage``
