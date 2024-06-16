//
//  AX + Basics.swift
//  
//
//  Created by Vaida on 6/17/24.
//

import ApplicationServices


// MARK: - Basic Properties
public extension AXUIElement {
    
    /// The role, or type, of this accessibility object (for example, AXButton).
    ///
    /// This string is for identification purposes only and does not need to be localized.
    @inlinable
    var role: String {
        get {
            try! self.attribute(for: kAXRoleAttribute, as: String.self)
        }
    }
    
    /// The subrole of this accessibility object (for example, AXCloseButton).
    ///
    /// The subrole provides additional information about the accessibility object to an assistive application. This string is for identification purposes only and does not need to be localized. This attribute is necessary only for an accessibility object whose AXRole attribute does not adequately describe its meaning.
    @inlinable
    var subrole: String {
        get throws(AXError) {
            try self.attribute(for: kAXSubroleAttribute)
        }
    }
    
    /// A localized string describing the role (for example, “button”).
    ///
    /// This string must be readable by (or speakable to) the user.
    @inlinable
    var roleDescription: String {
        get throws(AXError) {
            try self.attribute(for: kAXRoleDescriptionAttribute, as: String.self)
        }
    }
    
    /// A localized string containing help text for this accessibility object.
    @inlinable
    var help: String {
        get throws(AXError) {
            try self.attribute(for: kAXHelpAttribute)
        }
    }
    
    /// The title associated with this accessibility object.
    ///
    /// A title is text that the object displays as part of its visual interface, such as the text “OK” on an OK button. This string must be localizable and human-intelligible.
    @inlinable
    var title: String {
        get throws(AXError) {
            try self.attribute(for: kAXTitleAttribute)
        }
    }
    
    
    /// The position of the element.
    @inlinable
    var position: CGPoint {
        get throws(AXError) {
            try self.attribute(for: kAXPositionAttribute, cast: CGPoint.self)
        }
    }
    
    /// The size of the element.
    @inlinable
    var size: CGSize {
        get throws(AXError) {
            try self.attribute(for: kAXSizeAttribute, cast: CGSize.self)
        }
    }
    
    /// The bounds of the element.
    @inlinable
    var bounds: CGRect {
        get throws(AXError) {
            try CGRect(origin: position, size: size)
        }
    }
    
    
    /// A description of the element.
    @inlinable
    var description: CFString {
        get throws(AXError) {
            try self.attribute(for: kAXDescriptionAttribute, as: CFString.self)
        }
    }
    
    /// Whether the element has keyboard focus.
    @inlinable
    var focused: Bool {
        get throws(AXError) {
            try self.attribute(for: kAXFocusedAttribute, as: Bool.self)
        }
    }
    
    /// A unique identifier for the element.
    @inlinable
    var identifier: String {
        get {
            try! self.attribute(for: kAXIdentifierAttribute, as: String.self)
        }
    }
    
    /// Whether the element is the main element.
    @inlinable
    var isMain: Bool {
        get throws(AXError) {
            try self.attribute(for: kAXMainAttribute, as: Bool.self)
        }
    }
    
}


// MARK: - Methods
public extension AXUIElement {
    
    /// Move the element to the given `target`.
    @inlinable
    func move(to target: CGPoint) throws(AXError) {
        try set(attribute: target, for: kAXPositionAttribute, type: .cgPoint)
    }
    
    /// Resizes the element to the target `size`.
    @inlinable
    func resize(to size: CGSize) throws(AXError) {
        try set(attribute: size, for: kAXSizeAttribute, type: .cgSize)
    }
    
    /// Sets focus to the control.
    ///
    /// This method would move this control to the front.
    @inlinable
    func setFocus() throws(AXError) {
        try set(attribute: true, for: kAXMainAttribute)
    }
    
    /// Sets focus to the control.
    ///
    /// This method would move this control to the front.
    @available(*, deprecated, renamed: "setFocus")
    @inlinable
    func bringToFont() throws(AXError) {
        try self.setFocus()
    }
    
}
