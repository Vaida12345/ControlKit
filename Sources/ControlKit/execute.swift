//
//  execute.swift
//
//
//  Created by Vaida on 6/16/24.
//

import Foundation


/// Execute the command, waits for exit, and returns the `stdout`.
///
/// To list all content in the folder, use
/// ```swift
/// try print(execute("ls"))
/// // ControlKit.o
/// // ControlKit.swiftmodule
/// // ...
/// ```
///
/// - Parameters:
///   - command: The commands which will be executed in serial.
///
/// - Returns: If the `command` does not produce any results, it returns an empty `String`.
@discardableResult
public func execute(_ command: String...) throws -> String {
    let commands = command.joined(separator: "; ")
    
    let process = Process()
    let stdout = Pipe()
    process.standardOutput = stdout
    
    process.launchPath = "/bin/zsh"
    process.arguments = ["-c", commands]
    try process.run()
    
    process.waitUntilExit()
    
    let data = try stdout.fileHandleForReading.readToEnd() ?? Data()
    var out = String(data: data, encoding: .utf8)!
    while out.hasSuffix("\n") { out.removeLast() }
    return out
}
