
import Foundation
import ControlKit
import CoreGraphics
import ApplicationServices


@main
public struct MainApp {
    
    public static func main() async throws {
        
        for window in try Screen.windows() {
            print(window)
        }
        
        let control = try Screen.windows().filter({ $0.owner.name.contains("WeChat") }).compactMap({ $0.control }).first!
        
        // Focus on the window
        try control.focus()
        print(control.debugDescription)
        
//        let staticText = try windows.control[0][1][0][0][0][0][0][0]
    }
    
}
