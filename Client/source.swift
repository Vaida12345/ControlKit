
import Foundation
import ControlKit
import CoreGraphics
import ApplicationServices


@main
public struct MainApp {
    
    public static func main() async throws {
        
        try await Mouse.drag(from: CGPoint(x: 400, y: 400), to: CGPoint(x: 500, y: 500))
        
    }
    
}
