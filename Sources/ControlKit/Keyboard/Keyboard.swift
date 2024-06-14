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
    
    /// The predefined interval between key strokes.
    @inlinable
    public static var interval: Duration {
        .microseconds(5)
    }
    
    /// Press a key
    ///
    /// - Note: When passing a character literal, the case is ignored, for example, "A" and "a" would both represent the key "A".
    public static func press(_ key: Key) async throws {
        CGEvent(keyboardEventSource: nil, virtualKey: key.keyCode, keyDown: true)?
            .post(tap: .cghidEventTap)
        
        CGEvent(keyboardEventSource: nil, virtualKey: key.keyCode, keyDown: false)?
            .post(tap: .cghidEventTap)
        
        try await Task.sleep(for: interval)
    }
    
    /// Press a key
    ///
    /// - Note: When passing a character literal, the case is ignored, for example, "A" and "a" would both represent the key "A".
    public static func press(_ key: Key, modifiers: Modifier...) async throws {
        let modifier = modifiers.reduce(into: Modifier.none) { $0.formUnion($1) }
        let flags = modifier.flags
        
        let keyDownEvent = CGEvent(keyboardEventSource: nil, virtualKey: key.keyCode, keyDown: true)
        keyDownEvent?.flags = flags
        keyDownEvent?.post(tap: .cgAnnotatedSessionEventTap)
        
        let keyUpEvent = CGEvent(keyboardEventSource: nil, virtualKey: key.keyCode, keyDown: false)
        keyUpEvent?.flags = flags
        keyUpEvent?.post(tap: .cgAnnotatedSessionEventTap)
        
        try await Task.sleep(for: interval)
    }
    
}
