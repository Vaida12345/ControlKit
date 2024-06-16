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
        var description = ""
        if let title = try? self.title {
            description += title + " "
        }
        
        description += "(\(self.role)"
        
        if let role = try? self.subrole {
            description += ", \(role))"
        } else {
            description += ")"
        }
        
        if let identifier = try? self.identifier {
            description += " " + identifier
        }
        
        return description
    }
    
}

extension AXUIElement: @retroactive CustomDebugStringConvertible {
    
    public var debugDescription: String {
        String.recursiveDescription(of: self, children: { try? $0.children }, description: { $0.description })
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
        
        var value = "─ " + description(target) + "\n"
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
