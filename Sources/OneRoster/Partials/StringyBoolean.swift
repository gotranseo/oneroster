//
//  StringyBoolean.swift
//  OneRoster
//
//  Created by Jimmy McDermott on 5/25/19.
//

import Foundation

extension KeyedDecodingContainer where K: CodingKey {
    func stringBoolean(forKey key: KeyedDecodingContainer<K>.Key) throws -> Bool {
        let error = DecodingError.typeMismatch(Bool.self, .init(codingPath: [key], debugDescription: "Could not find bool value"))
        
        // check for bool value first
        if let boolValue = try? self.decode(Bool.self, forKey: key) {
            return boolValue
        } else if let stringValue = try? self.decode(String.self, forKey: key) {
            // now check for string value
            
            let lowercased = stringValue.lowercased()
            
            if lowercased == "t" || lowercased == "true" {
                return true
            } else if lowercased == "f" || lowercased == "false" {
                return false
            } else {
                throw error
            }
        } else {
            throw error
        }
    }
    
    func stringBooleanIfPresent(key: KeyedDecodingContainer<K>.Key) throws -> Bool? {
        let error = DecodingError.typeMismatch(Bool.self, .init(codingPath: [key], debugDescription: "Could not find bool value"))
        
        if let boolValue = try? self.decodeIfPresent(Bool.self, forKey: key) {
            return boolValue
        } else if let stringValue = try? self.decodeIfPresent(String.self, forKey: key) {
            // now check for string value
            
            let lowercased = stringValue?.lowercased()
            
            if lowercased == "t" || lowercased == "true" {
                return true
            } else if lowercased == "f" || lowercased == "false" {
                return false
            } else {
                throw error
            }
        } else {
            return nil
        }
    }
}
