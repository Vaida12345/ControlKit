//
//  Screen.swift
//  
//
//  Created by Vaida on 6/15/24.
//

import CoreGraphics


public struct Screen {
    
    /// Captures the current screen.
    ///
    /// - Parameters:
    ///   - displayID: The display id to capture. The default value is the display on screen.
    ///
    /// - Experiment: On a benchmark with `-O`, it takes 50ms on average to capture. That is around 200 frames per second. It took around 8% of the CPU to capture non-stop.
    @inlinable
    public static func capture(id displayID: CGDirectDisplayID = CGMainDisplayID()) -> CGImage? {
        if let imageRef = CGDisplayCreateImage(displayID) {
            return imageRef
        }
        return nil
    }
    
    /// The list of displays of the given kind.
    ///
    /// - Parameters:
    ///   - maxDisplays: This value determines the maximum number of display IDs that can be returned.
    @inlinable
    public static func displays(of kind: DisplayKind, maxDisplays: Int = 10) throws(CGError) -> [CGDirectDisplayID] {
        let displays = UnsafeMutablePointer<CGDirectDisplayID>.allocate(capacity: maxDisplays)
        defer {
            displays.deallocate()
        }
        var displayCount: UInt32 = 0
        let error: CGError
        
        if kind == .online {
            error = CGGetOnlineDisplayList(UInt32(maxDisplays), displays, &displayCount)
        } else {
            assert(kind == .active)
            error = CGGetActiveDisplayList(UInt32(maxDisplays), displays, &displayCount)
        }
        
        guard error == .success else { throw error }
        guard displayCount != 0 else { return [] }
        
        var array: [CGDirectDisplayID] = []
        let _displayCount = Int(displayCount)
        array.reserveCapacity(_displayCount)
        for i in 0..<_displayCount {
            array.append(displays[i])
        }
        return array
    }
    
    
    public enum DisplayKind: Sendable {
        
        /// Displays that are online (active, mirrored, or sleeping)
        case online
        
        /// Displays that are active for drawing
        case active
    }
    
}


extension CGError: @retroactive Error {
    
}
