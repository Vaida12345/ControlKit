
import ControlKit
import CoreGraphics


@main
public struct MainApp {
    
    public static func main() async throws {
        
        try await Keyboard.press("`", modifiers: .command)
        try await Task.sleep(for: .seconds(0.2))
        
        for _ in 0...100 {
            let pi = Double.pi.description
            try await Keyboard.press(pi)
            try await Keyboard.press(.enter)
        }

    }
    
}
