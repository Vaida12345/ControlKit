//
//  Window.swift
//  
//
//  Created by Vaida on 6/16/24.
//

import CoreGraphics
import Foundation
import ApplicationServices


extension Screen {
    
    /// A window on screen.
    ///
    /// Using ``control``, you could observe, and interact with this window.
    ///
    /// > Example:
    /// > This would move the first window of safari, and moves it to the top left corner.
    /// >
    /// > ```swift
    /// > let windows = try Screen.windows().first { 
    /// >       $0.owner.name == "Safari"
    /// > }!
    /// > try windows.control.move(to: .zero)
    /// > ```
    ///
    /// > Creation:
    /// > To create a window instance, use ``Screen/windows(options:)``
    public final class Window: CustomStringConvertible {
        
        /// kCGWindowName
        public let name: String?
        
        /// kCGWindowNumber
        public let id: CGWindowID
        
        /// The software that owns the window.
        public let owner: Owner
        
        /// kCGWindowBounds
        public let bounds: CGRect
        
        /// kCGWindowAlpha
        public let hasAlpha: Bool
        
        /// kCGWindowSharingState
        public let isSharing: Bool
        
        /// kCGWindowIsOnscreen
        public let isOnScreen: Bool
        
        /// kCGWindowMemoryUsage
        public let memoryUsage: Int
        
        /// kCGWindowLayer
        public let layer: Int
        
        /// kCGWindowStoreType
        public let storeType: NSNumber
        
        public private(set) lazy var control: AXUIElement? = { () -> AXUIElement? in
            let app = AXUIElementCreateApplication(pid_t(owner.pid))
            var windows: CFTypeRef?
            AXUIElementCopyAttributeValue(app, kAXWindowsAttribute as CFString, &windows)
            
            let windowArray = windows as! [AXUIElement]
            let _bounds = self.bounds
            
            for window in windowArray {
                guard let bounds = try? window.frame else { continue }
                if bounds == _bounds {
                    return window
                }
            }
            
            return nil
        }()
        
        
        public var description: String {
            var description = ""
            if let name {
                description += name + " (\(id))"
            } else {
                description += id.description
            }
            
            description += " - \(owner.description)"
            
            return description
        }
        
        
        internal init(info: [CFString: Any]) throws {
            guard let windowNumber = info[kCGWindowNumber] as? NSNumber,
                  let alpha = info[kCGWindowAlpha] as? NSNumber,
                  let sharing = info[kCGWindowSharingState] as? NSNumber,
                  let memory = info[kCGWindowMemoryUsage] as? NSNumber,
                  let layer = info[kCGWindowLayer] as? NSNumber,
                  let store = info[kCGWindowStoreType] as? NSNumber,
                  let ownerName = info[kCGWindowOwnerName] as? NSString,
                  let ownerPID = info[kCGWindowOwnerPID] as? NSNumber,
                  let boundsDict = info[kCGWindowBounds] as? [NSString: NSNumber],
                  let x = boundsDict["X"],
                  let y = boundsDict["Y"],
                  let width = boundsDict["Width"],
                  let height = boundsDict["Height"]
            else {
                throw ObtainWindowsError.invalidWindowInfo
            }

            self.id = CGWindowID(truncating: windowNumber)
            self.hasAlpha = alpha == 1
            self.isSharing = sharing == 1
            self.isOnScreen = (info[kCGWindowIsOnscreen] as? NSNumber).map { $0 == 1 } ?? false
            self.memoryUsage = Int(truncating: memory)
            self.layer = Int(truncating: layer)
            self.storeType = store
            self.owner = Owner(name: ownerName as String, pid: Int(truncating: ownerPID))
            self.bounds = CGRect(
                x: Int(truncating: x),
                y: Int(truncating: y),
                width: Int(truncating: width),
                height: Int(truncating: height)
            )
            self.name = (info[kCGWindowName] as? NSString) as? String
        }
        
        
        public struct Owner: Sendable, CustomStringConvertible, Equatable {
            
            /// kCGWindowOwnerName
            public let name: String
            
            /// kCGWindowOwnerPID
            public let pid: Int
            
            
            public var description: String {
                "\(name) (\(pid))"
            }
            
            public static func == (lhs: Owner, rhs: String) -> Bool {
                lhs.name == rhs
            }
            
            
            init(name: String, pid: Int) {
                self.name = name
                self.pid = pid
            }
            
        }
        
    }
    
}
