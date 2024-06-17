
import Foundation
import ControlKit
import CoreGraphics
import ApplicationServices


@main
public struct MainApp {
    
    public static func main() async throws {
        
        try? FileManager.default.removeItem(at: .desktopDirectory.appending(path: "file.mov"))
        
        // locate the window
        let window = try Screen.windows().filter({ $0.owner.name.contains("Safari") }).first!
        
        try window.control?.bringToFont()
        
        // start the record session. This method returns immediately after the record session is started
        let recorder = try Screen.record(window, imageOption: .boundsIgnoreFraming, to: .desktopDirectory.appending(path: "file.mov"), codec: .hevc)
        
        // the duration to record
        try await Task.sleep(for: .seconds(5))
        
        // tell the recorder to stop recording. This method will wait until the file is written.
        try await recorder.finish()
        
    }
    
}
