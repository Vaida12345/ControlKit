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
    var role: Role {
        get {
            let rawValue = try! self.attribute(for: kAXRoleAttribute, as: String.self)
            return Role(rawValue: rawValue)
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
    var frame: CGRect {
        get throws(AXError) {
            try CGRect(origin: position, size: size)
        }
    }
    
    
    /// A description of the element.
    @inlinable
    var elementDescription: CFString {
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
        get throws {
            try self.attribute(for: kAXIdentifierAttribute, as: String.self)
        }
    }
    
    /// Whether the element is the main element.
    @inlinable
    var isMain: Bool {
        get throws(AXError) {
            try self.attribute(for: kAXMainAttribute, as: Bool.self)
        }
    }
    
    /// Whether the element is minimized.
    @inlinable
    var minimized: Bool {
        get throws(AXError) {
            try self.attribute(for: kAXMinimizedAttribute, as: Bool.self)
        }
    }
    
    
    /// The close button for the element.
    @inlinable
    var closeButton: AXUIElement {
        get throws(AXError) {
            try self.attribute(for: kAXCloseButtonAttribute, as: AXUIElement.self)
        }
    }
    
    /// The zoom button for the element.
    @inlinable
    var zoomButton: AXUIElement {
        get throws(AXError) {
            try self.attribute(for: kAXZoomButtonAttribute, as: AXUIElement.self)
        }
    }
    
    /// The minimize button for the element.
    @inlinable
    var minimizeButton: AXUIElement {
        get throws(AXError) {
            try self.attribute(for: kAXMinimizeButtonAttribute, as: AXUIElement.self)
        }
    }
    
    /// The toolbar button for the element.
    @inlinable
    var toolbarButton: AXUIElement {
        get throws(AXError) {
            try self.attribute(for: kAXToolbarButtonAttribute, as: AXUIElement.self)
        }
    }
    
    /// The full screen button for the element.
    @inlinable
    var fullScreenButton: AXUIElement {
        get throws(AXError) {
            try self.attribute(for: kAXFullScreenButtonAttribute, as: AXUIElement.self)
        }
    }
    
    /// The default button.
    @inlinable
    var defaultButton: AXUIElement {
        get throws(AXError) {
            try self.attribute(for: kAXDefaultButtonAttribute, as: AXUIElement.self)
        }
    }
    
    /// The child elements.
    ///
    /// This would only return the direct children.
    ///
    /// - Note: Using ``debugDescription``, you can view the tree of an element.
    @inlinable
    var children: [AXUIElement] {
        get throws(AXError) {
            try self.attribute(for: kAXChildrenAttribute, as: [AXUIElement].self)
        }
    }
    
    /// Returns the child at the given index.
    ///
    /// `element[0]` would be equivalent to `element.children[0]`
    @inlinable
    subscript(_ i: Int) -> AXUIElement {
        get throws {
            let children = try self.children
            precondition(children.count > i, "Index out of range. The children are \(children.map(\.description).joined(separator: ", "))")
            return children[i]
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
    func focus() throws(AXError) {
        try set(attribute: true, for: kAXMainAttribute)
    }
    
    /// Sets focus to the control.
    ///
    /// This method would move this control to the front.
    @available(*, deprecated, renamed: "focus")
    @inlinable
    func bringToFont() throws(AXError) {
        try self.focus()
    }
    
    /// Minimize the window.
    @inlinable
    func minimize(_ isMinimized: Bool = true) throws(AXError) {
        try set(attribute: isMinimized, for: kAXMinimizedAttribute)
    }
    
    /// Sets the value to the element, as observed by ``value``.
    @inlinable
    func setValue(_ value: Any) throws(AXError) {
        try set(attribute: value as CFTypeRef, for: kAXValueAttribute)
    }
    
}
