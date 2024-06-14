//
//  Keyboard.swift
//
//
//  Created by Vaida on 6/14/24.
//


import Foundation
import CoreGraphics


/// The abstraction for keyboard.
public struct Keyboard {
    
    /// Press a key
    ///
    /// - Note: When passing a character literal, the case is ignored, for example, "A" and "a" would both represent the key "A".
    ///
    /// For consecutive events, you might want to use `Task.sleep` for gaps between events.
    ///
    /// ```swift
    /// Keyboard.press("`", modifiers: .command)
    /// try await Task.sleep(for: .seconds(0.01))
    /// Keyboard.press("a", modifiers: .shift)
    /// ```
    public static func press(_ key: Key) {
        CGEvent(keyboardEventSource: nil, virtualKey: key.keyCode, keyDown: true)?
            .post(tap: .cghidEventTap)
        
        CGEvent(keyboardEventSource: nil, virtualKey: key.keyCode, keyDown: false)?
            .post(tap: .cghidEventTap)
        
    }
    
    /// Press a key
    ///
    /// - Note: When passing a character literal, the case is ignored, for example, "A" and "a" would both represent the key "A".
    ///
    /// For consecutive events, you might want to use `Task.sleep` for gaps between events.
    ///
    /// ```swift
    /// Keyboard.press("`", modifiers: .command)
    /// try await Task.sleep(for: .seconds(0.01))
    /// Keyboard.press("a", modifiers: .shift)
    /// ```
    public static func press(_ key: Key, modifiers: Modifier...) {
        let modifier = modifiers.reduce(into: Modifier.none) { $0.formUnion($1) }
        let modifierKeys = modifier.keys
        
        for modifier in modifierKeys {
            CGEvent(keyboardEventSource: nil, virtualKey: modifier.keyCode, keyDown: true)?
                .post(tap: .cghidEventTap)
        }
        
        let keyDownEvent = CGEvent(keyboardEventSource: nil, virtualKey: key.keyCode, keyDown: true)
        keyDownEvent?.flags = modifier.flags
        keyDownEvent?.post(tap: .cghidEventTap)
        
        let keyUpEvent = CGEvent(keyboardEventSource: nil, virtualKey: key.keyCode, keyDown: false)
        keyUpEvent?.flags = modifier.flags
        keyUpEvent?.post(tap: .cghidEventTap)
        
        for modifier in modifierKeys.reversed() {
            CGEvent(keyboardEventSource: nil, virtualKey: modifier.keyCode, keyDown: false)?
                .post(tap: .cghidEventTap)
        }
    }
    
}
