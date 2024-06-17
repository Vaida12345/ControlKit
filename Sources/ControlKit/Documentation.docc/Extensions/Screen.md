
# ``ControlKit/Screen``

@Metadata {
    
    @PageImage(purpose: card, source: "screen", alt: nil)
    
    @PageColor(orange)
    
}

## Overview

This would capture every window of Finder and save it into a desktop folder.

```swift
let windows = try Screen.windows()

for window in windows.filter({ $0.owner.name == "Finder" }) {
    let image = Screen.capture(window)
    try image?.write(to: .desktopDirectory.appending(path: "Captures/\(window.description).png"))
}
```

### Controlling and inspecting window

Using in conjunction with ``ApplicationServices/AXUIElement``, you could control & inspect your ``Window``.

For example, This would close the first window of Finder.

```swift
let windows = try Screen.windows().first { $0.owner.name == "Finder" }!
try windows.control.closeButton.press()
```

### Record a window

With the ``record(_:listOption:imageOption:to:codec:)``, you could record a window, something that macOS screen recording cannot do.

For example, This would record the *finder* window that currently opens *computer*

```swift
// locate the window
let window = try Screen.windows().filter({ $0.owner.name.contains("Finder") && $0.name == "Vaida's MacBook Pro" }).first!

// start the record session. This method returns immediately after the record session is started
let recorder = try Screen.record(window, to: .desktopDirectory.appending(path: "file (alpha).mov"), codec: .proRes4444)

// the duration to record
try await Task.sleep(for: .seconds(1))

// tell the recorder to stop recording. This method will wait until the file is written.
try await recorder.finish()
```

With the `proRes4444` codec, the alpha component is preserved.


## Topics

### Working with Window

- ``Window``
- ``windows(options:)``

### Working with Display

- ``Display``
- ``displays(of:maxDisplays:)``

### Captures

- ``capture(_:listOption:imageOption:)``
- ``capture(_:target:)``

### Recordings

- ``record(_:target:to:)``
- ``record(_:listOption:imageOption:to:codec:)``
