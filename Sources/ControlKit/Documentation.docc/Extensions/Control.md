
# ``ApplicationServices/AXUIElement``

This structure is used to control ``Screen/Window`` using the ``Screen/Window/control`` property.


## Overview

This extension can be used to inspect and control ``Screen/Window``.

> Example:
> This would move the first window of safari that opens ChatGPT, and moves it to the top left corner.
> 
> ```swift
> let windows = try Screen.windows().first { $0.owner.name == "Safari" && $0.name!.contains("ChatGPT") }!
> try windows.control.move(to: .zero)
> ```

> Example:
> This would close the first window of Finder.
> 
> ```swift
> let windows = try Screen.windows().first { $0.owner.name == "Finder" }!
> try windows.control.closeButton.press()
> ```

> Tip: 
> To debug Accessibility, use *Accessibility Inspector* from *Xcode > Open Developer Tool*.
>
> To view the tree hierarchy, use ``debugDescription``.

## Topics

### Basic Inspections

- ``title``
- ``identifier``

### Controls

- ``focus()``
- ``minimize(_:)``
- ``bringToFont()``

### Working with positions

- ``position``
- ``size``
- ``frame``
- ``move(to:)``
- ``resize(to:)``

### Controls

- ``press()``
- ``showMenu()``
- ``confirm()``

### Children

The child elements, you could perform actions on them, such as ``press()``.

- ``closeButton``
- ``defaultButton``
- ``children``

### Roles

- ``role``
- ``subrole``
- ``roleDescription``

### Inspections

- ``description``
- ``focused``
- ``isMain``

### Interfaces

- ``attribute(for:as:)``
- ``set(attribute:for:)``
- ``attribute(for:cast:)``
- ``set(attribute:for:type:)``
