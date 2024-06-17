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
    
    /// Use the button to click the mouse at the specified location.
    @inlinable
    public static func tap(_ kind: TapKind = .primary, at position: CGPoint) {
        CGEvent(mouseEventSource: nil,
                mouseType: kind == .primary ? .leftMouseDown : .rightMouseDown,
                mouseCursorPosition: position,
                mouseButton: .left)? // the button is ignored
            .post(tap: .cghidEventTap)
        
        CGEvent(mouseEventSource: nil,
                mouseType: kind == .primary ? .leftMouseUp : .rightMouseUp,
                mouseCursorPosition: position,
                mouseButton: .left)? // the button is ignored
            .post(tap: .cghidEventTap)
    }
    
    public enum TapKind {
        /// Indicating left click
        case primary
        /// Indicating right click
        case secondary
    }
    
}
