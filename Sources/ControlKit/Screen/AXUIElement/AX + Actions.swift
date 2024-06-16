//
//  AX + Actions.swift
//  
//
//  Created by Vaida on 6/17/24.
//

import ApplicationServices


public extension AXUIElement {
    
    /// Increment action for an element.
    @inlinable
    func increment() throws(AXError) {
        try self.perform(kAXIncrementAction)
    }
    
    /// Decrement action for an element.
    @inlinable
    func decrement() throws(AXError) {
        try self.perform(kAXDecrementAction)
    }
    
    /// Cancel action for an element.
    @inlinable
    func cancel() throws(AXError) {
        try self.perform(kAXCancelAction)
    }
    
    /// Confirm action for an element.
    @inlinable
    func confirm() throws(AXError) {
        try self.perform(kAXConfirmAction)
    }
    
    /// Press action for an element.
    @inlinable
    func press() throws(AXError) {
        try self.perform(kAXPressAction)
    }
    
    /// Show menu action for an element.
    @inlinable
    func showMenu() throws(AXError) {
        try self.perform(kAXShowMenuAction)
    }
    
    /// Pick action for an element.
    @inlinable
    func pick() throws(AXError) {
        try self.perform(kAXPickAction)
    }
    
    /// Raise action for an element.
    @inlinable
    func raise() throws(AXError) {
        try self.perform(kAXRaiseAction)
    }
    
    /// Show alternate UI action for an element.
    @inlinable
    func showAlternateUI() throws(AXError) {
        try self.perform(kAXShowAlternateUIAction)
    }
    
    /// Show default UI action for an element.
    @inlinable
    func showDefaultUI() throws(AXError) {
        try self.perform(kAXShowDefaultUIAction)
    }
}
