//
//  Interoperation.swift
//
//
//  Created by Vaida on 6/15/24.
//

import Foundation


@available(macOS 13, *)
extension Keyboard {
    
    public struct Interoperation: StringInterpolationProtocol, ExpressibleByStringInterpolation {
        
        fileprivate enum Word {
            case literal(String)
            case stringInterpolation(String, Modifier)
            case keyInterpolation(Key, Modifier)
        }
        
        fileprivate var words: [Word]
        
        
        public init(literalCapacity: Int, interpolationCount: Int) {
            self.words = []
            self.words.reserveCapacity(literalCapacity + interpolationCount)
        }
        
        public init(stringLiteral value: String) {
            self.words = [.literal(value)]
        }
        
        public mutating func appendLiteral(_ literal: String) {
            self.words.append(.literal(literal))
        }
        
        public mutating func appendInterpolation(_ key: Key) {
            self.words.append(.keyInterpolation(key, .none))
        }
        
        public mutating func appendInterpolation(_ key: Key, modifiers: Modifier...) {
            self.words.append(.keyInterpolation(key, modifiers.reduce(into: Modifier.none, { $0.formUnion($1) })))
        }
        
        public mutating func appendInterpolation(_ literal: String) {
            self.words.append(.stringInterpolation(literal, .none))
        }
        
        public mutating func appendInterpolation(_ literal: String, modifiers: Modifier...) {
            self.words.append(.stringInterpolation(literal, modifiers.reduce(into: Modifier.none, { $0.formUnion($1) })))
        }
        
    }
    
    
    /// Press a series of keys.
    ///
    /// - Note: When passing a character literal, the case is ignored, for example, "A" and "a" would both represent the key "A".
    ///
    /// - Parameters:
    ///   - keys: The keys to press as expressed as interoperation.
    public static func press(_ keys: Interoperation) async throws {
        for word in keys.words {
            switch word {
            case .literal(let string):
                for character in string {
                    try await self.press(Key(stringLiteral: String(character)))
                }
            case .stringInterpolation(let string, let modifier):
                for character in string {
                    try await self.press(Key(stringLiteral: String(character)), modifiers: modifier)
                }
            case .keyInterpolation(let key, let modifier):
                try await self.press(key, modifiers: modifier)
            }
        }
    }
    
    /// Press a series of keys.
    ///
    /// - Note: When passing a character literal, the case is ignored, for example, "A" and "a" would both represent the key "A".
    ///
    /// - Parameters:
    ///   - keys: The keys to press as expressed as interoperation.
    ///   - modifiers: The global modifiers for the `keys`.
    public static func press(_ keys: Interoperation, modifiers: Modifier...) async throws {
        let modifiers = modifiers.reduce(into: Modifier.none) { $0.formUnion($1) }
        
        for word in keys.words {
            switch word {
            case .literal(let string):
                for character in string {
                    try await self.press(Key(stringLiteral: String(character)), modifiers: modifiers)
                }
            case .stringInterpolation(let string, let modifier):
                for character in string {
                    try await self.press(Key(stringLiteral: String(character)), modifiers: modifier.union(modifiers))
                }
            case .keyInterpolation(let key, let modifier):
                try await self.press(key, modifiers: modifier.union(modifiers))
            }
        }
    }
    
    
    /// Press a series of keys.
    ///
    /// - Note: When passing a character literal, the case is ignored, for example, "A" and "a" would both represent the key "A".
    ///
    /// - Parameters:
    ///   - keys: The keys to press as expressed as String.
    public static func press(_ keys: String) async throws {
        try await self.press(Interoperation(stringLiteral: keys))
    }
    
    /// Press a series of keys.
    ///
    /// - Note: When passing a character literal, the case is ignored, for example, "A" and "a" would both represent the key "A".
    ///
    /// - Parameters:
    ///   - keys: The keys to press as expressed as String.
    ///   - modifiers: The global modifiers for the `keys`.
    public static func press(_ keys: String, modifiers: Modifier...) async throws {
        try await self.press(Interoperation(stringLiteral: keys), modifiers: modifiers.reduce(into: Modifier.none, { $0.formUnion($1) }))
    }
    
}
