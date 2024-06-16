//
//  Display.swift
//  
//
//  Created by Vaida on 6/16/24.
//

import CoreGraphics


extension Screen {
    
    /// A display.
    ///
    /// > Creation:
    /// > To create a display instance, use ``Screen/displays``
    public struct Display: Sendable {
        
        /// The display ID.
        public let id: CGDirectDisplayID
        
        /// The bounds of a display in the global display coordinate space
        ///
        /// The bounds of the display, expressed as a rectangle in the global display coordinate space (relative to the upper-left corner of the main display).
        public var bounds: CGRect {
            CGDisplayBounds(id)
        }
        
        /// The physical screen size in millimeters.
        ///
        /// If Extended Display Identification Data (EDID) for the display device is not available, the size is estimated based on the device width and height in pixels from `CGDisplayBounds(_:)`, with an assumed resolution of 2.835 pixels/mm or 72 dpi, a reasonable guess for displays predating EDID support.
        public var physicalSize: CGSize? {
            CGDisplayScreenSize(id)
        }
        
        /// Returns information about a display’s current configuration.
        public var displayMode: CGDisplayMode? {
            CGDisplayCopyDisplayMode(id)
        }
        
        /// Returns the color space for a display.
        public var colorSpace: CGColorSpace? {
            CGDisplayCopyColorSpace(id)
        }
        
        /// Returns a Boolean value indicating whether a display is active.
        public var isActive: Bool {
            CGDisplayIsActive(id) == 1
        }
        
        /// Returns a Boolean value indicating whether a display is sleeping (and is therefore not drawable).
        public var isAsleep: Bool {
            CGDisplayIsAsleep(id) == 1
        }
        
        /// Returns a Boolean value indicating whether a display is built-in, such as the internal display in portable systems.
        public var isBuiltin: Bool {
            CGDisplayIsBuiltin(id) == 1
        }
        
        /// Returns a Boolean value indicating whether a display is the main display.
        public var isMain: Bool {
            CGDisplayIsMain(id) == 1
        }
        
        /// Returns a Boolean value indicating whether a display is connected or online.
        public var isOnline: Bool {
            CGDisplayIsOnline(id) == 1
        }
        
        /// Returns a Boolean value indicating whether a display is running in a stereo graphics mode.
        public var isStereo: Bool {
            CGDisplayIsStereo(id) == 1
        }
        
        /// Returns the model number of a display monitor.
        ///
        /// - Returns: A model number for the monitor associated with the specified display, or a constant to indicate an exception—see the discussion below.
        ///
        /// This function uses I/O Kit to identify the monitor associated with the specified display. The return value depends on the following:
        /// - If I/O Kit can identify the monitor, the product ID code for the monitor is returned.
        /// - If I/O Kit can’t identify the monitor, kDisplayProductIDGeneric is returned.
        /// - If no monitor is connected, `nil` is returned.
        public var modelNumber: Int? {
            let number = CGDisplayModelNumber(id)
            if number == 0xFFFFFFFF { return nil }
            return Int(number)
        }
        
        /// Returns the display size in pixel units.
        public var size: CGSize {
            CGSize(width: CGDisplayPixelsWide(id), height: CGDisplayPixelsHigh(id))
        }
        
        /// Returns the primary display in a hardware mirroring set.
        ///
        /// - Returns: The primary display in the mirror set. If `self` is not hardware-mirrored, this function simply returns `self`.
        ///
        /// In hardware mirroring, the contents of a single framebuffer are rendered in two or more displays simultaneously. The mirrored displays are said to be in a *hardware mirroring set*.
        /// 
        /// At the discretion of the device driver, one of the displays in a hardware mirroring set is designated as the primary display. The device driver binds the drawing engine, hardware accelerator, and 3D engine to the primary display and directs all drawing operations to this display.
        public var primaryDisplay: Display {
            Display(displayID: CGDisplayPrimaryDisplay(id))
        }
        
        /// Returns the rotation angle of a display in degrees.
        ///
        /// - Returns: The rotation angle of the display in degrees, or 0 if the display is not valid.
        ///
        /// This function returns the rotation angle of a display in a clockwise direction. For example, if the specified display is rotated clockwise 90 degrees, then this function returns 90.0. After a 90-degree clockwise rotation, the physical bottom of the display is on the left side and the physical top is on the right side.
        public var rotation: Double {
            CGDisplayRotation(id)
        }
        
        /// Returns the serial number of a display monitor.
        ///
        /// - Returns: A serial number for the monitor associated with the specified display, or a constant to indicate an exception—see the discussion below.
        ///
        /// This function uses I/O Kit to identify the monitor associated with the specified display.
        ///
        /// If I/O Kit can identify the monitor:
        /// - If the manufacturer has encoded a serial number for the monitor, the number is returned.
        /// - If there is no encoded serial number, 0x00000000 is returned.
        ///
        /// If I/O Kit cannot identify the monitor:
        /// - If a monitor is connected to the display, 0x00000000 is returned.
        /// - If no monitor is connected to the display hardware, 0xFFFFFFFF is returned.
        ///
        /// Note that a serial number is meaningful only in conjunction with a specific vendor and product or model.
        public var serialNumber: Int {
            get throws(GetSerialNumberError) {
                let serialNumber = CGDisplaySerialNumber(id)
                if serialNumber == 0x00000000 {
                    throw .noEncodedSerialNumber
                } else if serialNumber == 0xFFFFFFFF {
                    throw .displayNotConnected
                }
                
                return Int(serialNumber)
            }
        }
        
        /// Returns the logical unit number of a display.
        ///
        /// The logical unit number represents a particular node in the I/O Kit device tree associated with the display’s framebuffer.
        ///
        /// For a particular hardware configuration, this value will not change when the attached monitor is changed. The number will change, though, if the I/O Kit device tree changes, for example, when hardware is reconfigured, drivers are replaced, or significant changes occur to I/O Kit. Therefore keep in mind that this number may vary across login sessions.
        public var unitNumber: Int {
            Int(CGDisplayUnitNumber(id))
        }
        
        
        /// Moves the mouse cursor to a specified point relative to the upper-left corner of the display.
        ///
        /// The function doesn’t generate events as a result of this move. The action clips points that lie outside the desktop to its bounds.
        ///
        /// - Parameters:
        ///   - target: The coordinates of a point in local display space. The origin is the upper-left corner of the specified display.
        public func moveCursor(to target: CGPoint) throws {
            let error = CGDisplayMoveCursorToPoint(id, target)
            guard error == .success else { throw error }
        }
        
        
        /// Returns the display of the main display.
        ///
        /// The main display is the display with its screen location at (0,0) in the global display coordinate space. In a system without display mirroring, the display with the menu bar is typically the main display.
        ///
        /// If mirroring is enabled and the menu bar appears on more than one display, this function provides a reliable way to find the main display.
        ///
        /// In case of hardware mirroring, the drawable display becomes the main display. In case of software mirroring, the display with the highest resolution and deepest pixel depth typically becomes the main display.
        public static let main = Display(displayID: CGMainDisplayID())
        
        
        init(displayID: CGDirectDisplayID) {
            self.id = displayID
        }
        
        
        public enum GetSerialNumberError: Error, Sendable {
            case displayNotConnected
            case noEncodedSerialNumber
        }
        
    }
    
}
