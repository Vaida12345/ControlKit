//
//  Screen.swift
//  
//
//  Created by Vaida on 6/15/24.
//

import CoreGraphics
import Foundation


/// Different to `ScreenCaptureKit`, The methods works well in executables without identities.
public struct Screen {
    
    /// Captures the current screen.
    ///
    /// - Parameters:
    ///   - displayID: The display id to capture. The default value is the display on screen.
    ///   - target: The rect of interest
    ///
    /// - Experiment: On a benchmark with `-O`, it takes 50ms on average to capture. That is around 200 frames per second. It took around 8% of the CPU to capture non-stop.
    ///
    /// To obtain a list of displays, use ``displays``.
    @inlinable
    public static func capture(_ display: Display = .main, target: CGRect? = nil) -> CGImage? {
        if let target,
           let imageRef = CGDisplayCreateImage(display.id, rect: target) {
            return imageRef
        } else if let imageRef = CGDisplayCreateImage(display.id) {
            return imageRef
        }
        
        return nil
    }
    
    /// The list of displays of the given kind.
    ///
    /// - Parameters:
    ///   - kind: The display kind.
    ///   - maxDisplays: This value determines the maximum number of display IDs that can be returned.
    public static func displays(
        of kind: DisplayKind = .active,
        maxDisplays: Int = 10
    ) throws(CGError) -> [Display] {
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
        
        var array: [Display] = []
        let _displayCount = Int(displayCount)
        array.reserveCapacity(_displayCount)
        for i in 0..<_displayCount {
            array.append(Display(displayID: displays[i]))
        }
        return array
    }
    
    
    /// Returns all windows satisfying `options`.
    ///
    /// - Parameters:
    ///   - options: The options describing which window dictionaries to return. Typical options let you return dictionaries for all windows or for windows above or below the window specified in the relativeToWindow parameter.
    ///
    /// Generating the system windows is a relatively expensive operation. As always, you should profile your code and adjust your usage of this function appropriately for your needs.
    public static func windows(options: CGWindowListOption = [.excludeDesktopElements]) throws -> [Window] {
        let windowListInfo = CGWindowListCopyWindowInfo(options, kCGNullWindowID) as NSArray?
        
        // Check if we got the window list
        guard let windowList = windowListInfo as? [[CFString: Any]] else {
            throw ObtainWindowsError.noWindowList
        }
        
        return windowList.map(Window.init)
    }
    
    /// Captures the image of a screen, window, or a region. It is commonly used for taking screenshots of specific windows or areas of the display.
    ///
    /// - Parameters:
    ///   - window: This parameter can be used to specify a particular window for capturing, or can be `nil` if the listOption does not require a specific window ID.
    ///   - screenBounds: A CGRect that specifies the bounding box for the image to be captured. This can define a specific area of the screen or the entire screen.
    ///   - listOption: Specifies the scope of windows to include in the image.
    ///   - imageOption: Specifies the image rendering options. See discussion for more.
    ///
    /// For `imageOption`, you could pass:
    /// - `boundsIgnoreFraming` for ignoring the shadow.
    ///
    /// - Note: A window obtained ``windows()`` does not guarantee such window is capture-able.
    public static func capture(
        _ window: Window? = nil,
        listOption: CGWindowListOption = .optionIncludingWindow,
        imageOption: CGWindowImageOption = []
    ) -> CGImage? {
        CGWindowListCreateImage(.null, listOption, window?.id ?? kCGNullWindowID, imageOption)
    }
    
    
    public enum DisplayKind: Sendable {
        
        /// Displays that are online (active, mirrored, or sleeping)
        case online
        
        /// Displays that are active for drawing
        case active
    }
    
    
    public enum ObtainWindowsError: Error {
        case noWindowList
    }
    
}


extension CGError: @retroactive Error {
    
}
