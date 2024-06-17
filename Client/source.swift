
import Foundation
import ControlKit
import CoreGraphics
import ApplicationServices


@main
public struct MainApp {
    
    public static func main() async throws {
        
        try? FileManager.default.removeItem(at: .desktopDirectory.appending(path: "file (alpha).mov"))
        
//        for window in try Screen.windows(options: .excludeDesktopElements) {
//            print(window, window.name)
//        }
        
        let window = try Screen.windows(options: .excludeDesktopElements).filter({ $0.owner.name.contains("Finder") && $0.name == "Vaida's MacBook Pro" }).first!
        let recorder = try Screen.record(window, to: .desktopDirectory.appending(path: "file (alpha).mov"), codec: .proRes4444)
        
        try await Task.sleep(for: .seconds(1))

        try await recorder.finish()
        
    }
    
}
