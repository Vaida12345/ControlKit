//
//  Mouse.swift
//
//
//  Created by Vaida on 6/14/24.
//

import Foundation
import CoreGraphics


/// The abstraction for mouse.
public struct Mouse {
    
    /// Move the mouse to the specified location.
    @inlinable
    public static func move(to position: CGPoint) {
        CGEvent(mouseEventSource: nil,
                mouseType: .mouseMoved,
                mouseCursorPosition: position,
                mouseButton: .left)? // the button is ignored
            .post(tap: .cghidEventTap)
        // Location: Between the hardware and the HID (Human Interface Device) system.
        // Purpose: To observe and filter low-level input events before they are processed by the HID system.
    }
    
    /// Use the left button to click the mouse at the specified location.
    @inlinable
    public static func tap(at position: CGPoint) {
        CGEvent(mouseEventSource: nil,
                mouseType: .leftMouseDown,
                mouseCursorPosition: position,
                mouseButton: .left)? // the button is ignored
            .post(tap: .cghidEventTap)
        
        CGEvent(mouseEventSource: nil,
                mouseType: .leftMouseUp,
                mouseCursorPosition: position,
                mouseButton: .left)? // the button is ignored
            .post(tap: .cghidEventTap)
    }
    
    /// Use the right button to click the mouse at the specified location.
    @inlinable
    public static func controlTap(at position: CGPoint) {
        CGEvent(mouseEventSource: nil,
                mouseType: .rightMouseDown,
                mouseCursorPosition: position,
                mouseButton: .left)? // the button is ignored
            .post(tap: .cghidEventTap)
        
        CGEvent(mouseEventSource: nil,
                mouseType: .rightMouseUp,
                mouseCursorPosition: position,
                mouseButton: .left)? // the button is ignored
            .post(tap: .cghidEventTap)
    }
    
}
