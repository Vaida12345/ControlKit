//
//  Window.swift
//  
//
//  Created by Vaida on 6/16/24.
//

import CoreGraphics
import Foundation


extension Screen {
    
    /// A window on screen.
    ///
    /// > Creation:
    /// > To create a window instance, use ``Screen/windows``
    public struct Window: Sendable, CustomStringConvertible {
        
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
        
        
        internal init(info: [CFString: Any]) {
            self.id = CGWindowID(truncating: info[kCGWindowNumber] as! NSNumber)
            self.hasAlpha = (info[kCGWindowAlpha] as! NSNumber) == 1
            self.isSharing = (info[kCGWindowSharingState] as! NSNumber) == 1
            self.isOnScreen = (info[kCGWindowIsOnscreen] as? NSNumber).map { $0 == 1 } ?? false
            self.memoryUsage = Int(truncating: info[kCGWindowMemoryUsage] as! NSNumber)
            self.layer = Int(truncating: info[kCGWindowLayer] as! NSNumber)
            self.storeType = info[kCGWindowStoreType] as! NSNumber
            
            let ownerName = (info[kCGWindowOwnerName] as! NSString) as String
            let ownerPID = Int(truncating: info[kCGWindowOwnerPID] as! NSNumber)
            self.owner = Owner(name: ownerName, pid: ownerPID)
            
            let bounds = info[kCGWindowBounds] as! [NSString: NSNumber]
            self.bounds = CGRect(
                x: Int(truncating: bounds["X"]!),
                y: Int(truncating: bounds["Y"]!),
                width: Int(truncating: bounds["Width"]!),
                height: Int(truncating: bounds["Height"]!)
            )
            
            self.name = (info[kCGWindowName] as? NSString) as? String
        }
        
        
        public struct Owner: Sendable, CustomStringConvertible {
            
            /// kCGWindowOwnerName
            public let name: String
            
            /// kCGWindowOwnerPID
            public let pid: Int
            
            
            public var description: String {
                "\(name) (\(pid))"
            }
            
            
            init(name: String, pid: Int) {
                self.name = name
                self.pid = pid
            }
            
        }
        
    }
    
}
