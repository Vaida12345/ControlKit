//
//  Screen.swift
//  
//
//  Created by Vaida on 6/15/24.
//

import CoreGraphics


public struct Screen {
    
    public static func capture() -> CGImage? {
        let mainDisplayId = CGMainDisplayID()
        if let imageRef = CGDisplayCreateImage(mainDisplayId) {
            return imageRef
        }
        return nil
    }
    
}
