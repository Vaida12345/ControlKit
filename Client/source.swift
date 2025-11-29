
import Foundation
import ControlKit
import CoreGraphics
import ApplicationServices


@main
public struct MainApp {
    
    public static func main() async throws {
        
        // locate the window
        let window = try Screen.windows().filter({ $0.owner.name.contains("Finder") && $0.name == "Vaida's MacBook Pro" }).first!
        
        print(URL.desktopDirectory.appending(path: "file (alpha).mov"))
        
        
        // start the record session. This method returns immediately after the record session is started
        let recorder = try Screen.record(window, to: .desktopDirectory.appending(path: "file (alpha).mov"), codec: .proRes4444)
        
        
        // the duration to record
        try await Task.sleep(for: .seconds(10))
        
        
        // tell the recorder to stop recording. This method will wait until the file is written.
        try await recorder.finish()
        
    }
    
}
