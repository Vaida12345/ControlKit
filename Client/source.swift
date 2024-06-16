
import Foundation
import ControlKit
import CoreGraphics


@main
public struct MainApp {
    
    public static func main() async throws {
        
        let windows = try Screen.windows()
        let filter = windows.filter({ $0.owner.name == "IINA" })
        
        for window in filter {
            let image = Screen.capture(window)
            try image?.write(to: .desktopDirectory.appending(path: "Captures/\(window.description).png"))
        }
        
    }
    
}
