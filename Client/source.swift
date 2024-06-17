
import Foundation
import ControlKit
import CoreGraphics
import ApplicationServices


@main
public struct MainApp {
    
    public static func main() async throws {
        
        let window = try Screen.windows().filter({ $0.owner.name.contains("Finder") && $0.name == "Vaida's MacBook Pro" }).first!
        let recorder = try Screen.record(window, to: .desktopDirectory.appending(path: "file.mov"))
        
        try await Task.sleep(for: .seconds(1))
        try await recorder.finish()
        
    }
    
}
