
import Foundation
import ControlKit
import CoreGraphics
import ApplicationServices


@main
public struct MainApp {
    
    public static func main() async throws {
        
        let windows = try Screen.windows().first(where: { $0.owner.name == "Finder" })!
        print(windows.control.role)
        try! print(windows.control.subrole)
        try! print(windows.control.roleDescription)
        try! print(windows.control.title)
        try! print(windows.control.focused)
        try! windows.control.setFocus()
        print(">>>")
        try! print(windows.control.focused)
        try! print(windows.control.isMain)
//        try! windows.control.set(attribute: false, for: kAXMainAttribute)
        try! print(windows.control.isMain)
        try! windows.control.set(attribute: true, for: kAXMainAttribute)
        try! print(windows.control.isMain)
//        try! windows.control.set(attribute: false, for: kAXMainAttribute)
        try! print(windows.control.isMain)
        try! windows.control.set(attribute: true, for: kAXMainAttribute)
        try! print(windows.control.isMain)
        try! print(windows.control.closeButton.press())
        
    }
    
}
