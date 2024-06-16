
import ControlKit
import CoreGraphics


@main
public struct MainApp {
    
    public static func main() async throws {
        
        try print(Screen.displays(of: .active))
        
    }
    
}
