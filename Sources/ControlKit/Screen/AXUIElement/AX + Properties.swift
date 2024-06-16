//
//  AXUI + Properties.swift
//  
//
//  Created by Vaida on 6/17/24.
//

import ApplicationServices


public extension AXUIElement {
    
    /// The value associated with this accessibility object (for example, a scroller value).
    ///
    /// The value of an accessibility object is user-modifiable and represents the setting of the associated user interface element, such as the contents of an editable text field or the position of a scroller.
    @inlinable
    var value: CFNumber {
        get throws(AXError) {
            try self.attribute(for: kAXValueAttribute)
        }
    }
    
    /// The minimum value this accessibility object can display (for example, the minimum value of a scroller control).
    ///
    /// This attribute is used only in conjunction with the AXValue attribute.
    @inlinable
    var minValue: CFNumber {
        get throws(AXError) {
            try self.attribute(for: kAXMinValueAttribute)
        }
    }
    
    /// The maximum value this accessibility object can display (for example, the maximum value of a scroller control).
    ///
    /// This attribute is used only in conjunction with the AXValue attribute.
    @inlinable
    var maxValue: CFNumber {
        get throws(AXError) {
            try self.attribute(for: kAXMaxValueAttribute)
        }
    }
    
    /// Indicates whether the user can interact with the accessibility object.
    ///
    /// For example, the AXEnabled attribute of a disabled button is false. This attribute is required for accessibility objects that represent views, menus, and menu items. This attribute is not required for accessibility objects that represent windows.
    @inlinable
    var enabled: Bool {
        get throws(AXError) {
            try self.attribute(for: kAXEnabledAttribute)
        }
    }
    
    /// The parent element.
    @inlinable
    var parent: AXUIElement {
        get throws(AXError) {
            try self.attribute(for: kAXParentAttribute, as: AXUIElement.self)
        }
    }
    
    /// The child elements.
    @inlinable
    var children: CFArray {
        get throws(AXError) {
            try self.attribute(for: kAXChildrenAttribute, as: CFArray.self)
        }
    }
    
    /// The selected child elements.
    @inlinable
    var selectedChildren: CFArray {
        get throws(AXError) {
            try self.attribute(for: kAXSelectedChildrenAttribute, as: CFArray.self)
        }
    }
    
    /// The visible child elements.
    @inlinable
    var visibleChildren: CFArray {
        get throws(AXError) {
            try self.attribute(for: kAXVisibleChildrenAttribute, as: CFArray.self)
        }
    }
    
    /// The window containing the element.
    @inlinable
    var window: AXUIElement {
        get throws(AXError) {
            try self.attribute(for: kAXWindowAttribute, as: AXUIElement.self)
        }
    }
    
    /// The top-level UI element containing this element.
    @inlinable
    var topLevelUIElement: AXUIElement {
        get throws(AXError) {
            try self.attribute(for: kAXTopLevelUIElementAttribute, as: AXUIElement.self)
        }
    }
    
    /// The URL associated with the element.
    @inlinable
    var url: URL {
        get throws(AXError) {
            try self.attribute(for: kAXURLAttribute, as: URL.self)
        }
    }
    
    /// Whether the element is editable.
    @inlinable
    var isEditable: Bool {
        get throws(AXError) {
            try self.attribute(for: kAXIsEditableAttribute, as: Bool.self)
        }
    }
    
    /// Indicates whether the user interface element represented by this accessibility object has been edited.
    ///
    /// For example, a document window indicates it has been edited by displaying a black dot in its close button.
    @inlinable
    var edited: Bool {
        get throws(AXError) {
            try self.attribute(for: kAXEditedAttribute, as: Bool.self)
        }
    }
    
    /// The element representing the title.
    @inlinable
    var titleUIElement: AXUIElement {
        get throws(AXError) {
            try self.attribute(for: kAXTitleUIElementAttribute, as: AXUIElement.self)
        }
    }
    
    /// Elements linked to this one.
    @inlinable
    var linkedUIElements: CFArray {
        get throws(AXError) {
            try self.attribute(for: kAXLinkedUIElementsAttribute, as: CFArray.self)
        }
    }
    
    /// The header element for this element.
    @inlinable
    var header: AXUIElement {
        get throws(AXError) {
            try self.attribute(for: kAXHeaderAttribute, as: AXUIElement.self)
        }
    }
    
    /// A description of the element's value.
    @inlinable
    var valueDescription: String {
        get throws(AXError) {
            try self.attribute(for: kAXValueDescriptionAttribute, as: String.self)
        }
    }
    
    
    /// The command character associated with a menu item.
    @inlinable
    var menuItemCmdChar: String {
        get throws(AXError) {
            try self.attribute(for: kAXMenuItemCmdCharAttribute, as: String.self)
        }
    }
    
    /// The virtual key code for the menu item.
    @inlinable
    var menuItemCmdVirtualKey: CFNumber {
        get throws(AXError) {
            try self.attribute(for: kAXMenuItemCmdVirtualKeyAttribute, as: CFNumber.self)
        }
    }
    
    /// The modifier keys for the menu item.
    @inlinable
    var menuItemCmdModifiers: CFNumber {
        get throws(AXError) {
            try self.attribute(for: kAXMenuItemCmdModifiersAttribute, as: CFNumber.self)
        }
    }
    
    /// The rows disclosed in a disclosure element.
    @inlinable
    var disclosedRows: CFArray {
        get throws(AXError) {
            try self.attribute(for: kAXDisclosedRowsAttribute, as: CFArray.self)
        }
    }
    
    /// The row that discloses this element.
    @inlinable
    var disclosedByRow: AXUIElement {
        get throws(AXError) {
            try self.attribute(for: kAXDisclosedByRowAttribute, as: AXUIElement.self)
        }
    }
    
    /// The horizontal scroll bar associated with this element.
    @inlinable
    var horizontalScrollBar: AXUIElement {
        get throws(AXError) {
            try self.attribute(for: kAXHorizontalScrollBarAttribute, as: AXUIElement.self)
        }
    }
    
    /// The vertical scroll bar associated with this element.
    @inlinable
    var verticalScrollBar: AXUIElement {
        get throws(AXError) {
            try self.attribute(for: kAXVerticalScrollBarAttribute, as: AXUIElement.self)
        }
    }
    
    /// The overflow button for this element.
    @inlinable
    var overflowButton: AXUIElement {
        get throws(AXError) {
            try self.attribute(for: kAXOverflowButtonAttribute, as: AXUIElement.self)
        }
    }
    
    /// The filename associated with this element.
    @inlinable
    var filename: String {
        get throws(AXError) {
            try self.attribute(for: kAXFilenameAttribute, as: String.self)
        }
    }
    
    /// Whether the element is expanded.
    @inlinable
    var expanded: Bool {
        get throws(AXError) {
            try self.attribute(for: kAXExpandedAttribute, as: Bool.self)
        }
    }
    
    /// The selected text within the element.
    @inlinable
    var selectedText: String {
        get throws(AXError) {
            try self.attribute(for: kAXSelectedTextAttribute, as: String.self)
        }
    }
    
    /// The range of the selected text.
    @inlinable
    var selectedTextRange: CFRange {
        get throws(AXError) {
            try self.attribute(for: kAXSelectedTextRangeAttribute, cast: CFRange.self)
        }
    }
    
    /// The number of characters in the element.
    @inlinable
    var numberOfCharacters: CFNumber {
        get throws(AXError) {
            try self.attribute(for: kAXNumberOfCharactersAttribute, as: CFNumber.self)
        }
    }
    
    /// The range of visible characters in the element.
    @inlinable
    var visibleCharacterRange: CFRange {
        get throws(AXError) {
            try self.attribute(for: kAXVisibleCharacterRangeAttribute, cast: CFRange.self)
        }
    }
    
    /// Elements that share focus with this element.
    @inlinable
    var sharedFocusElements: CFArray {
        get throws(AXError) {
            try self.attribute(for: kAXSharedFocusElementsAttribute, as: CFArray.self)
        }
    }
    
    /// The line number of the insertion point.
    @inlinable
    var insertionPointLineNumber: NSNumber {
        get throws(AXError) {
            try self.attribute(for: kAXInsertionPointLineNumberAttribute, as: CFNumber.self)
        }
    }
    
    /// The sort direction of the element.
    @inlinable
    var sortDirection: CFNumber {
        get throws(AXError) {
            try self.attribute(for: kAXSortDirectionAttribute, as: CFNumber.self)
        }
    }
    
    /// The title of the column.
    @inlinable
    var columnTitle: AXUIElement {
        get throws(AXError) {
            try self.attribute(for: kAXColumnTitleAttribute, as: AXUIElement.self)
        }
    }
    
    /// The index of the element.
    @inlinable
    var index: CFNumber {
        get throws(AXError) {
            try self.attribute(for: kAXIndexAttribute, as: CFNumber.self)
        }
    }
    
    /// The number of rows in the element.
    @inlinable
    var rowCount: CFNumber {
        get throws(AXError) {
            try self.attribute(for: kAXRowCountAttribute, as: CFNumber.self)
        }
    }
    
    /// The number of columns in the element.
    @inlinable
    var columnCount: CFNumber {
        get throws(AXError) {
            try self.attribute(for: kAXColumnCountAttribute, as: CFNumber.self)
        }
    }
    
    /// Whether the rows are ordered.
    @inlinable
    var orderedByRow: Bool {
        get throws(AXError) {
            try self.attribute(for: kAXOrderedByRowAttribute, as: Bool.self)
        }
    }
    
    /// The units used for horizontal measurement.
    @inlinable
    var horizontalUnits: String {
        get throws(AXError) {
            try self.attribute(for: kAXHorizontalUnitsAttribute, as: String.self)
        }
    }
    
    /// The units used for vertical measurement.
    @inlinable
    var verticalUnits: String {
        get throws(AXError) {
            try self.attribute(for: kAXVerticalUnitsAttribute, as: String.self)
        }
    }
    
    /// The search button associated with this element.
    @inlinable
    var searchButton: AXUIElement {
        get throws(AXError) {
            try self.attribute(for: kAXSearchButtonAttribute, as: AXUIElement.self)
        }
    }
    
    /// The search field associated with this element.
    @inlinable
    var searchField: AXUIElement {
        get throws(AXError) {
            try self.attribute(for: kAXSearchFieldSubrole, as: AXUIElement.self)
        }
    }
    
    /// The clear button associated with this element.
    @inlinable
    var clearButton: AXUIElement {
        get throws(AXError) {
            try self.attribute(for: kAXClearButtonAttribute, as: AXUIElement.self)
        }
    }
    
    /// The area of the element that can be used to resize it.
    @inlinable
    var growArea: AXUIElement {
        get throws(AXError) {
            try self.attribute(for: kAXGrowAreaAttribute, as: AXUIElement.self)
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
    
    /// Whether the element is minimized.
    @inlinable
    var minimized: Bool {
        get throws(AXError) {
            try self.attribute(for: kAXMinimizedAttribute, as: Bool.self)
        }
    }
    
    /// The extras menu bar associated with this element.
    @inlinable
    var extrasMenuBar: AXUIElement {
        get throws(AXError) {
            try self.attribute(for: kAXExtrasMenuBarAttribute, as: AXUIElement.self)
        }
    }
    
    /// The proxy element for this element.
    @inlinable
    var proxy: AXUIElement {
        get throws(AXError) {
            try self.attribute(for: kAXProxyAttribute, as: AXUIElement.self)
        }
    }
    
    /// Whether the element is selected.
    @inlinable
    var selected: Bool {
        get throws(AXError) {
            try self.attribute(for: kAXSelectedAttribute, as: Bool.self)
        }
    }
    
    /// The cells in the element that are visible.
    @inlinable
    var visibleCells: CFArray {
        get throws(AXError) {
            try self.attribute(for: kAXVisibleCellsAttribute, as: CFArray.self)
        }
    }
    
    /// The row header elements in the table.
    @inlinable
    var rowHeaderUIElements: CFArray {
        get throws(AXError) {
            try self.attribute(for: kAXRowHeaderUIElementsAttribute, as: CFArray.self)
        }
    }
    
    /// The column header elements in the table.
    @inlinable
    var columnHeaderUIElements: CFArray {
        get throws(AXError) {
            try self.attribute(for: kAXColumnHeaderUIElementsAttribute, as: CFArray.self)
        }
    }
    
    /// The button to increment the value of the element.
    @inlinable
    var incrementButton: AXUIElement {
        get throws(AXError) {
            try self.attribute(for: kAXIncrementButtonAttribute, as: AXUIElement.self)
        }
    }
    
    /// The button to decrement the value of the element.
    @inlinable
    var decrementButton: AXUIElement {
        get throws(AXError) {
            try self.attribute(for: kAXDecrementButtonAttribute, as: AXUIElement.self)
        }
    }
    
    /// The previous contents of the element.
    @inlinable
    var previousContents: CFArray {
        get throws(AXError) {
            try self.attribute(for: kAXPreviousContentsAttribute, as: CFArray.self)
        }
    }
    
    /// The next contents of the element.
    @inlinable
    var nextContents: CFArray {
        get throws(AXError) {
            try self.attribute(for: kAXNextContentsAttribute, as: CFArray.self)
        }
    }
    
    /// The contents of the element.
    @inlinable
    var contents: CFArray {
        get throws(AXError) {
            try self.attribute(for: kAXContentsAttribute, as: CFArray.self)
        }
    }
    
}
