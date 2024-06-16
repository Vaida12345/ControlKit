
import Foundation
import ControlKit
import CoreGraphics
import ApplicationServices


@main
public struct MainApp {
    
    public static func main() async throws {
        
        let windows = try Screen.windows().first(where: { $0.owner.name == "Safari" })!
        
        // Focus on the window
        try windows.control.focus()
        
        let toolbar = try windows.control.children.first(where: { $0.role == "AXToolbar" })!
        
        let textField = try toolbar[0][0][1][1] // Navigate to the textField. You can print the hierarchy using `toolbar.debugDescription`.
        
        try textField.showDefaultUI() // This could represent the UI by clicking on it. Safari would require a user to tap on it before making any adjustments
        try textField.setValue("https://github.com/apple")
        try textField.confirm() // This represents the default action by pressing ⏎.
    }
    
}
