
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
