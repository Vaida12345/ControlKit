//
//  Keyboard.Key.swift
//
//
//  Created by Vaida on 6/14/24.
//

import CoreGraphics


/// User-friendly interface to key code.
///
/// You could use integer literals, character literals, and static properties to express a value.
///
/// - Note: When passing a character literal, the case is ignored, for example, "A" and "a" would both represent the key "A".
///
/// The following keys are not implemented.
/// ```
/// 0x5D        Yen (JIS layout)
/// 0x5E        Underscore (JIS layout)
/// 0x5F        Keypad Comma/Separator (JIS layout)
/// 0x66        Eisu (JIS layout)
/// 0x68        Kana (JIS layout)
/// 0x75        Del (Below the Help Key)
/// 0x7F        Power (on PC)
/// ```
public struct Key: ExpressibleByStringLiteral, ExpressibleByIntegerLiteral, Sendable {
    
    internal let keyCode: CGKeyCode
    
    private static let characters: [Character: UInt16] = [
        "A" : 0x00,
        "S" : 0x01,
        "D" : 0x02,
        "F" : 0x03,
        "H" : 0x04,
        "G" : 0x05,
        "Z" : 0x06,
        "X" : 0x07,
        "C" : 0x08,
        "V" : 0x09,
        "B" : 0x0B,
        "Q" : 0x0C,
        "W" : 0x0D,
        "E" : 0x0E,
        "R" : 0x0F,
        "Y" : 0x10,
        "T" : 0x11,
        "1" : 0x12,
        "2" : 0x13,
        "3" : 0x14,
        "4" : 0x15,
        "6" : 0x16,
        "5" : 0x17,
        "=" : 0x18,
        "9" : 0x19,
        "7" : 0x1A,
        "-" : 0x1B,
        "8" : 0x1C,
        "0" : 0x1D,
        "]" : 0x1E,
        "O" : 0x1F,
        "U" : 0x20,
        "[" : 0x21,
        "I" : 0x22,
        "P" : 0x23,
        "L" : 0x25,
        "J" : 0x26,
        "'" : 0x27,
        "K" : 0x28,
        ";" : 0x29,
        "," : 0x2B,
        "\\" : 0x2A,
        "/" : 0x2C,
        "N" : 0x2D,
        "M" : 0x2E,
        "." : 0x2F,
        "\t" : 0x30,
        "*" : 0x31,
        "~" : 0x32,
        "`" : 0x32
    ]
    
    
    private init(keyCode: CGKeyCode) {
        self.keyCode = keyCode
    }
    
    public init(integerLiteral value: UInt16) {
        precondition(value <= 9, "Value \(value) is not representable on the number pad.")
        self.init(stringLiteral: "\(value)")
    }
    
    public init(stringLiteral value: StringLiteralType) {
        precondition(value.count == 1, "StringLiteral \(value) exceeds a CGKeyCode could contain")
        let character = value.uppercased().first!
        precondition(character.isASCII, "Character \(character) exceeds a CGKeyCode could contain: Not ASCII")
        if let index = Key.characters[character] {
            self.init(keyCode: index)
        } else {
            fatalError("Character \(character) exceeds a CGKeyCode could contain: It is not in the predefined set")
        }
    }
    
    
    /// The *Section* key (ISO layout).
    public static let section = Key(keyCode: 0x0A)
    
    /// The *Enter* Key. The key code is 36 (0x24)
    public static let enter = Key(keyCode: 36)
    
    /// The *Space* Key. The key code is 49 (0x31)
    public static let space = Key(keyCode: 49)
    
    /// The *Delete* Key. The key code is 51 (0x33)
    public static let delete = Key(keyCode: 51)
    
    /// The *enter* Key on Powerbook.
    public static let enter_powerbook = Key(keyCode: 0x34)
    
    /// The *Tab* Key. The key code is 48 (0x30)
    public static let tab = Key(keyCode: 48)
    
    /// The *Esc* Key. The key code is 53 (0x35)
    public static let escape = Key(keyCode: 48)
    
    /// The *Command* Key.
    ///
    /// The key code for left is 55 (0x37)
    /// The key code for right is 43 (0x36)
    public static func command(_ location: Location = .left) -> Key {
        switch location {
        case .left:
            Key(keyCode: 55)
        case .right:
            Key(keyCode: 54)
        }
    }
    
    /// The *Shift* Key.
    ///
    /// The key code for left is 56 (0x38)
    /// The key code for right is 60 (0x3C)
    public static func shift(_ location: Location = .left) -> Key {
        switch location {
        case .left:
            Key(keyCode: 56)
        case .right:
            Key(keyCode: 60)
        }
    }
    
    /// The *Caps Lock* Key. The key code is 57 (0x39)
    public static let capsLock = Key(keyCode: 57)
    
    /// The *Option* (*Alt*) Key.
    ///
    /// The key code for left is 58 (0x3A)
    /// The key code for right is 61 (0x3D)
    public static func option(_ location: Location = .left) -> Key {
        switch location {
        case .left:
            Key(keyCode: 58)
        case .right:
            Key(keyCode: 61)
        }
    }
    
    /// The *Control* Key.
    ///
    /// The key code for left is 59 (0x3B)
    /// The key code for right is 62 (0x3E)
    public static func control(_ location: Location = .left) -> Key {
        switch location {
        case .left:
            Key(keyCode: 59)
        case .right:
            Key(keyCode: 62)
        }
    }
    
    /// The *Fn* / *Globe* Key.
    public static let fn = Key(keyCode: 0x3F)
    
    /// A Function key.
    ///
    /// ```swift
    /// .F(1) // F1
    /// ```
    public static func F(_ i: UInt8) -> Key {
        switch i {
        case 1:
            Key(keyCode: 0x7A)
        case 2:
            Key(keyCode: 0x78)
        case 3:
            Key(keyCode: 0x63)
        case 4:
            Key(keyCode: 0x76)
        case 5:
            Key(keyCode: 0x60)
        case 6:
            Key(keyCode: 0x61)
        case 7:
            Key(keyCode: 0x62)
        case 8:
            Key(keyCode: 0x64)
        case 9:
            Key(keyCode: 0x65)
        case 10:
            Key(keyCode: 0x6D)
        case 11:
            Key(keyCode: 0x67)
        case 12:
            Key(keyCode: 0x6F)
        case 13:
            Key(keyCode: 0x69)
        case 14:
            Key(keyCode: 0x6B)
        case 15:
            Key(keyCode: 0x71)
        case 16:
            Key(keyCode: 0x6A)
        case 17:
            Key(keyCode: 0x40)
        case 18:
            Key(keyCode: 0x4F)
        case 19:
            Key(keyCode: 0x50)
        case 20:
            Key(keyCode: 0x5A)
        default:
            fatalError("Undefined key: F\(i)")
        }
    }
    
    /// A Number Pad key.
    public static func numberPad(_ i: NumberPad) -> Key {
        Key(keyCode: i.keyCode)
    }
    
    /// A volume control key.
    public static func volume(_ i: VolumeControl) -> Key {
        switch i {
        case .up:
            Key(keyCode: 0x48)
        case .down:
            Key(keyCode: 0x49)
        case .mute:
            Key(keyCode: 0x4A)
        }
    }
    
    /// The *Menu* key on PC.
    public static let menu = Key(keyCode: 0x6E)
    
    /// The *Help* key.
    public static let help = Key(keyCode: 0x72)
    
    /// The *Home* key.
    public static let home = Key(keyCode: 0x73)
    
    /// A page control key.
    public static func page(_ i: VerticalDirection) -> Key {
        switch i {
        case .up:
            Key(keyCode: 0x74)
        case .down:
            Key(keyCode: 0x79)
        }
    }
    
    /// The *End* key.
    public static let end = Key(keyCode: 0x77)
    
    /// A arrow direction key.
    public static func arrow(_ i: ArrowDirection) -> Key {
        switch i {
        case .left:
            Key(keyCode: 0x7B)
        case .right:
            Key(keyCode: 0x7C)
        case .down:
            Key(keyCode: 0x7D)
        case .up:
            Key(keyCode: 0x7E)
        }
    }
    
    
    public enum Location {
        case left, right
    }
    
    public enum VolumeControl {
        case up, down, mute
    }
    
    public enum VerticalDirection {
        case up, down
    }
    
    public enum ArrowDirection {
        case up, down, left, right
    }
    
    public struct NumberPad: ExpressibleByIntegerLiteral, ExpressibleByStringLiteral, Sendable {
        
        fileprivate let keyCode: CGKeyCode
        
        
        private static let characters: [Character: UInt16] = [
            "." : 0x41,
            "*" : 0x43,
            "+" : 0x45,
            "/" : 0x4B,
            "\n" : 0x4C,
            "-" : 0x4E,
            "=" : 0x51,
        ]
        
        private init(keyCode: CGKeyCode) {
            self.keyCode = keyCode
        }
        
        public init(integerLiteral value: UInt16) {
            precondition(value <= 9, "Value \(value) is not representable on the number pad.")
            let code = value - 0x52
            self.init(keyCode: code)
        }
        
        public init(stringLiteral value: StringLiteralType) {
            precondition(value.count == 1, "StringLiteral \(value) exceeds a NumberPad could contain")
            let character = value.first!
            precondition(character.isASCII, "Character \(character) exceeds a NumberPad could contain: Not ASCII")
            if let index = Key.characters[character] {
                self.init(keyCode: index)
            } else {
                fatalError("Character \(character) exceeds a NumberPad could contain: It is not in the predefined set")
            }
        }
        
        
        /// The *Enter* key on the number pad.
        public static let enter = NumberPad(keyCode: 0x4C)
        
        /// The *NumLock* (*Clear*) key on the number pad.
        public static let numLock = NumberPad(keyCode: 0x47)
        
    }
    }
