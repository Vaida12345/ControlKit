//
//  AXUIElement.swift
//
//
//  Created by Vaida on 6/16/24.
//

import ApplicationServices


public extension AXUIElement {
    
    /// Returns the attribute for the given key.
    @inlinable
    func attribute<T>(for key: String, as: T.Type = T.self) throws(AXError) -> T {
        var value: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(self, key as CFString, &value)
        guard result == .success else { throw result }
        
        return value as! T
    }
    
    /// Returns the attribute for the given key.
    @inlinable
    func attribute<T>(for key: String, cast: T.Type) throws(AXError) -> T {
        let value = try attribute(for: key, as: CFTypeRef.self)
        let _value = value as! AXValue
        let type = AXValueGetType(_value)
        
        let _result = UnsafeMutablePointer<T>.allocate(capacity: 1)
        defer { _result.deallocate() }
        assert(AXValueGetValue(_value, type, _result))
        return _result.pointee
    }
    
    
    /// Sets the attribute for the given key
    @inlinable
    func set<T>(attribute: T, for key: String) throws(AXError) {
        let result = AXUIElementSetAttributeValue(self, key as CFString, attribute as CFTypeRef)
        
        guard result == .success else { throw result }
    }
    
    /// Sets the attribute for the given key
    @inlinable
    func set<T>(attribute: T, for key: String, type: AXValueType) throws(AXError) {
        let _attribute = UnsafeMutablePointer<T>.allocate(capacity: 1)
        _attribute.initialize(to: attribute)
        defer { _attribute.deallocate() }
        let value = AXValueCreate(type, _attribute)
        let result = AXUIElementSetAttributeValue(self, key as CFString, value as CFTypeRef)
        
        guard result == .success else { throw result }
    }
    
    /// Performs an action
    @inlinable
    func perform(_ action: String) throws(AXError) {
        let result = AXUIElementPerformAction(self, action as CFString)
        
        guard result == .success else { throw result }
    }
}


extension AXUIElement: @retroactive CustomStringConvertible {
    
    public var description: String {
        let role = self.role
        
        var description = ""
        if let title = try? self.title,
           !title.isEmpty {
            description += title + " "
        } else if let content = try? self.value {
            let _content = "\(content)"
            if !_content.isEmpty && _content != "(\n)" {
                description += _content + " "
            }
        }
        
        description += "(\(role)"
        
        if let role = try? self.subrole {
            description += ", \(role))"
        } else {
            description += ")"
        }
        
        if let url = try? self.url {
            description += " \(url)"
        }
        
        return description
    }
    
}

extension AXUIElement: @retroactive CustomDebugStringConvertible {
    
    /// The children hierarchy.
    ///
    /// ```
    /// let window = try Screen.windows(options: .excludeDesktopElements).filter({ $0.owner.name.contains("Finder") && $0.name == "Vaida's MacBook Pro" }).first!
    /// print(window.control!.debugDescription)
    /// ```
    /// ```
    /// ─Vaida's MacBook Pro (window, AXStandardWindow)
    /// ├─(splitGroup)
    /// │ ├─(scrollArea)
    /// │ │ ╰─(outline)
    /// │ │   ├─(row, AXOutlineRow)
    /// │ │   │ ╰─(cell)
    /// │ │   │   ╰─Favorites (staticText)
    /// │ │   ├─(row, AXOutlineRow)
    /// │ │   │ ╰─(cell)
    /// │ │   │   ├─Study (staticText)
    /// │ │   │   ╰─(image)
    /// │ │   ├─(row, AXOutlineRow)
    /// │ │   │ ╰─(cell)
    /// │ │   │   ├─Packages (staticText)
    /// │ │   │   ╰─(image)
    /// │ │   ├─(row, AXOutlineRow)
    /// │ │   │ ╰─(cell)
    /// │ │   │   ├─Desktop (staticText)
    /// │ │   │   ╰─(image)
    /// │ │   ├─(row, AXOutlineRow)
    /// │ │   │ ╰─(cell)
    /// │ │   │   ╰─iCloud (staticText)
    /// │ │   ├─(row, AXOutlineRow)
    /// │ │   │ ╰─(cell)
    /// │ │   │   ├─iCloud Drive (staticText)
    /// │ │   │   ├─(image)
    /// │ │   │   ╰─1 (progressIndicator)
    /// │ │   ╰─(column)
    /// │ ├─143 (splitter)
    /// │ ╰─(splitGroup)
    /// │   ╰─(scrollArea)
    /// │     ╰─(list, AXCollectionList)
    /// │       ╰─(list, AXSectionList)
    /// │         ├─(group)
    /// │         │ ╰─Macintosh HD (image) file:///
    /// │         ╰─(group)
    /// ├─(toolbar)
    /// ├─(button, AXCloseButton)
    /// ├─(button, AXFullScreenButton)
    /// │ ╰─(group)
    /// ├─(button, AXMinimizeButton)
    /// ╰─Vaida's MacBook Pro (staticText)
    /// ```
    public var debugDescription: String {
        String.recursiveDescription(of: self, children: { try? $0.children }, description: { $0.description })
    }
    
}

extension AXUIElement {
    
    public enum Role: RawRepresentable {
        case splitGroup
        case splitter
        case tabGroup
        case group
        case scrollArea
        case window
        case webArea
        /// A link, which has a ``AXUIElement/title``.
        case link
        case heading
        case button
        case list
        case staticText
        case scrollBar
        case image
        case row
        case cell
        case toolbar
        case opaqueProviderGroup
        case textField
        case listMarker
        case popUpButton
        case column
        case table
        case comboBox
        case radioButton
        case checkBox
        case unknown
        case valueIndicator
        case textArea
        case outline
        case progressIndicator
        case raw(String)
        
        public var rawValue: String {
            switch self {
            case .splitGroup: "AXSplitGroup"
            case .splitter: "AXSplitter"
            case .tabGroup: "AXTabGroup"
            case .group: "AXGroup"
            case .scrollArea: "AXScrollArea"
            case .window: "AXWindow"
            case .webArea: "AXWebArea"
            case .link: "AXLink"
            case .heading: "AXHeading"
            case .button: "AXButton"
            case .list: "AXList"
            case .staticText: "AXStaticText"
            case .scrollBar: "AXScrollBar"
            case .image: "AXImage"
            case .row: "AXRow"
            case .cell: "AXCell"
            case .toolbar: "AXToolbar"
            case .opaqueProviderGroup: "AXOpaqueProviderGroup"
            case .textField: "AXTextField"
            case .listMarker: "AXListMarker"
            case .popUpButton: "AXPopUpButton"
            case .column: "AXColumn"
            case .table: "AXTable"
            case .comboBox: "AXComboBox"
            case .radioButton: "AXRadioButton"
            case .checkBox: "AXCheckBox"
            case .unknown: "AXUnknown"
            case .valueIndicator: "AXValueIndicator"
            case .textArea: "AXTextArea"
            case .outline: "AXOutline"
            case .progressIndicator: "AXProgressIndicator"
            case let .raw(string): string
            }
        }
        
        public init(rawValue: String) {
            self = switch rawValue {
            case "AXSplitGroup": .splitGroup
            case "AXSplitter": .splitter
            case "AXTabGroup": .tabGroup
            case "AXGroup": .group
            case "AXScrollArea": .scrollArea
            case "AXWindow": .window
            case "AXWebArea": .webArea
            case "AXLink": .link
            case "AXHeading": .heading
            case "AXButton": .button
            case "AXList": .list
            case "AXStaticText": .staticText
            case "AXScrollBar": .scrollBar
            case "AXImage": .image
            case "AXRow": .row
            case "AXCell": .cell
            case "AXToolbar": .toolbar
            case "AXOpaqueProviderGroup": .opaqueProviderGroup
            case "AXTextField": .textField
            case "AXListMarker": .listMarker
            case "AXPopUpButton": .popUpButton
            case "AXColumn": .column
            case "AXTable": .table
            case "AXComboBox": .comboBox
            case "AXRadioButton": .radioButton
            case "AXCheckBox": .checkBox
            case "AXUnknown": .unknown
            case "AXValueIndicator": .valueIndicator
            case "AXTextArea": .textArea
            case "AXOutline": .outline
            case "AXProgressIndicator": .progressIndicator
            default: .raw(rawValue)
            }
        }
    }
    
}

private extension String {
    
    static private func printChild<T>(_ child: T, header: String, into target: inout String, isLast: Bool, children: (T) -> [T]?, description: (T) -> String) {
        let childDescription = recursiveDescription(of: child, children: children, description: description)
        let components = childDescription.components(separatedBy: "\n").filter({ !$0.isEmpty })
        if let first = components.first {
            target += "\(header)\(first)\n"
        }
        for line in components.dropFirst() {
            target += "\(isLast ? " " : "│") \(line)\n"
        }
    }
    
    static func recursiveDescription<T>(of target: T, children: (T) -> [T]?, description: (T) -> String) -> String {
        
        var value = "─" + description(target) + "\n"
        if let _children = children(target) {
            for child in _children.dropLast() {
                printChild(child, header: "├", into: &value, isLast: false, children: children, description: description)
            }
            if let last = _children.last {
                printChild(last, header: "╰", into: &value, isLast: true, children: children, description: description)
            }
        }
        return value
        
    }
    
}


extension AXError: @retroactive Error, @retroactive CustomStringConvertible {
    
    public var description: String {
        switch self.rawValue {
        case 0:
            return "AXError.success: No error occurred. "
            
        case -25200:
            return "AXError.failure: A system error occurred, such as the failure to allocate an object. "
            
        case -25201:
            return "AXError.illegalArgument: An illegal argument was passed to the function. "
            
        case -25202:
            return "AXError.invalidUIElement: The AXUIElementRef passed to the function is invalid. "
            
        case -25203:
            return "AXError.invalidUIElementObserver: The AXObserverRef passed to the function is not a valid observer. "
            
        case -25204:
            return "AXError.cannotComplete: The function cannot complete because messaging failed in some way or because the application with which the function is communicating is busy or unresponsive. "
            
        case -25205:
            return "AXError.attributeUnsupported: The attribute is not supported by the AXUIElementRef. "
            
        case -25206:
            return "AXError.actionUnsupported: The action is not supported by the AXUIElementRef. "
            
        case -25207:
            return "AXError.notificationUnsupported: The notification is not supported by the AXUIElementRef. "
            
        case -25208:
            return "AXError.notImplemented: Indicates that the function or method is not implemented (this can be returned if a process does not support the accessibility API). "
            
        case -25209:
            return "AXError.notificationAlreadyRegistered: This notification has already been registered for. "
            
        case -25210:
            return "AXError.notificationNotRegistered: Indicates that a notification is not registered yet. "
            
        case -25211:
            return "AXError.apiDisabled: The accessibility API is disabled (as when, for example, the user deselects \"Enable access for assistive devices\" in Universal Access Preferences). "
            
        case -25212:
            return "AXError.noValue: The requested value or AXUIElementRef does not exist. "
            
        case -25213:
            return "AXError.parameterizedAttributeUnsupported: The parameterized attribute is not supported by the AXUIElementRef. "
            
        case -25214:
            return "AXError.notEnoughPrecision: Not enough precision. "
            
        default:
            fatalError("Unknown AXError code: \(rawValue)")
        }
    }
    
}
