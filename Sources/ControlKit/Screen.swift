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
    /// - Experiment: On a benchmark with `-O`, it takes 50ms on average to capture. That is around 200 frames per second. It took around 8% of the CPU to capture non-stop.
    @inlinable
    public static func capture() -> CGImage? {
        let mainDisplayId = CGMainDisplayID()
        if let imageRef = CGDisplayCreateImage(mainDisplayId) {
            return imageRef
        }
        return nil
    }
    
}
