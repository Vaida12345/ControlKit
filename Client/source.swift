
import Foundation
import ControlKit
import CoreGraphics
import ApplicationServices


@main
public struct MainApp {
    
    public static func main() async throws {
        
        let writer = try Screen.record(to: .desktopDirectory.appending(path: "file.m4v"))
        try await Task.sleep(for: .seconds(2))
        try await writer.finish()
        
    }
    
}
