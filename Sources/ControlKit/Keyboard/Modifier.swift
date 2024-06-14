//
//  Modifier.swift
//  
//
//  Created by Vaida on 6/14/24.
//

import Foundation
import CoreGraphics


extension Keyboard {
    
    public struct Modifier: OptionSet, Sendable, CaseIterable {
        
        public var rawValue: UInt8
        
        internal var keys: [Key] {
            var keys: [Key] = []
            if self.contains(.command) { keys.append(.command()) }
            if self.contains(.control) { keys.append(.control()) }
            if self.contains(.option)  { keys.append(.option())  }
            if self.contains(.shift)   { keys.append(.shift())   }
            if self.contains(.fn)      { keys.append(.fn)        }
            return keys
        }
        
        internal var flags: CGEventFlags {
            var flags: CGEventFlags = []
            if self.contains(.command) { flags.formUnion(.maskCommand)     }
            if self.contains(.control) { flags.formUnion(.maskControl)     }
            if self.contains(.option)  { flags.formUnion(.maskAlternate)   }
            if self.contains(.shift)   { flags.formUnion(.maskShift)       }
            if self.contains(.fn)      { flags.formUnion(.maskSecondaryFn) }
            return flags
        }
        
        public init(rawValue: UInt8) {
            self.rawValue = rawValue
        }
        
        
        public static let none     = Modifier(rawValue: 0 << 0)
        
        public static let command  = Modifier(rawValue: 1 << 0)
        
        public static let control  = Modifier(rawValue: 1 << 1)
        
        public static let option   = Modifier(rawValue: 1 << 2)
        
        public static let shift    = Modifier(rawValue: 1 << 3)
        
        public static let fn       = Modifier(rawValue: 1 << 4)
        
        
        public static let allCases: [Modifier] = [.command, .control, .option, .shift, .fn]
        
    }
    
}
