//
//  Mouse.swift
//
//
//  Created by Vaida on 6/14/24.
//

import Foundation
import CoreGraphics
import AppKit


/// The abstraction for mouse.
public struct Mouse {
    
    /// The current mouse location.
    @inlinable
    public static var location: CGPoint {
        NSEvent.mouseLocation
    }
    
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
    
    /// Use the mouse to click the mouse at the specified location.
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
    
    /// Press and hold the mouse button, until ``mouseUp(_:at:)``
    @inlinable
    public static func mouseDown(_ kind: TapKind = .primary, at position: CGPoint) {
        CGEvent(mouseEventSource: nil,
                mouseType: kind == .primary ? .leftMouseDown : .rightMouseDown,
                mouseCursorPosition: position,
                mouseButton: .left)? // the button is ignored
            .post(tap: .cghidEventTap)
    }
    
    /// Release the button by ``mouseDown(_:at:)``.
    @inlinable
    public static func mouseUp(_ kind: TapKind = .primary, at position: CGPoint) {
        CGEvent(mouseEventSource: nil,
                mouseType: kind == .primary ? .leftMouseUp : .rightMouseUp,
                mouseCursorPosition: position,
                mouseButton: .left)? // the button is ignored
            .post(tap: .cghidEventTap)
    }
    
    /// Simulate drag event.
    ///
    /// The interval used is `0.1s`.
    @inlinable
    public static func drag(_ kind: TapKind = .primary, from source: CGPoint, to target: CGPoint) async throws {
        CGEvent(mouseEventSource: nil,
                mouseType: kind == .primary ? .leftMouseDown : .rightMouseDown,
                mouseCursorPosition: source,
                mouseButton: .left)? // the button is ignored
            .post(tap: .cghidEventTap)
        
        try await Task.sleep(for: .seconds(0.1))
        
        CGEvent(mouseEventSource: nil,
                mouseType: kind == .primary ? .leftMouseDragged : .rightMouseDragged,
                mouseCursorPosition: source,
                mouseButton: .left)? // the button is ignored
            .post(tap: .cghidEventTap)
        
        try await Task.sleep(for: .seconds(0.1))
        
        CGEvent(mouseEventSource: nil,
                mouseType: kind == .primary ? .leftMouseDragged : .rightMouseDragged,
                mouseCursorPosition: target,
                mouseButton: .left)? // the button is ignored
            .post(tap: .cghidEventTap)
        
        try await Task.sleep(for: .seconds(0.1))
        
        CGEvent(mouseEventSource: nil,
                mouseType: kind == .primary ? .leftMouseUp : .rightMouseUp,
                mouseCursorPosition: target,
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
