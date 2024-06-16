
# ``ControlKit/Keyboard``

@Metadata {
    
    @PageImage(purpose: card, source: "keyboard", alt: nil)
    
    @PageColor(blue)
    
}

## Overview

The following would create a new windows, and print *hello world*, and hit enter.

```swift
try await Keyboard.press("N", modifiers: .command)
try await Task.sleep(for: .seconds(0.1)) // wait and ensures the new window is opened.

try await Keyboard.press("Hello World")
```

- Important: When passing a character literal, the case is ignored, for example, “A” and “a” would both represent the key “A”, and the typed result is "a".

## Topics

### Pressing a Key

- ``press(_:)-8tfct``
- ``press(_:)-8o4v8``
- ``press(_:)-2hzgm``


### Pressing with Modifiers

Modifiers are applied to the entire first field. 

- ``press(_:modifiers:)-4ihcq``
- ``press(_:modifiers:)-c34``
- ``press(_:modifiers:)-4a4t4``

### Keys

Along with `Character` and `String`, this is also a type that `press(_:)` accepts.

- ``Key``


### Type Properties

The predefined interval between key strokes. This interval is applied at the end of each key stroke.

- ``interval``

### Modifiers

- ``Modifier``

### Interoperation

- ``Interoperation``
