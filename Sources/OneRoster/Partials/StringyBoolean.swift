//===----------------------------------------------------------------------===//
//
// This source file is part of the OneRoster open source project
//
// Copyright (c) 2021 the OneRoster project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

extension KeyedDecodingContainer where K: CodingKey {
    func stringBoolean(forKey key: KeyedDecodingContainer<K>.Key) throws -> Bool {
        let error = DecodingError.typeMismatch(Bool.self, .init(codingPath: [key], debugDescription: "Could not find bool value"))
        guard let val = stringBooleanIfPresent(key: key) else { throw error }
        return val
    }
    
    func stringBooleanIfPresent(key: KeyedDecodingContainer<K>.Key) -> Bool? {
        if let boolValue = try? self.decodeIfPresent(Bool.self, forKey: key) {
            return boolValue
        } else if let stringValue = try? self.decodeIfPresent(String.self, forKey: key) {
            // now check for string value
            
            let lowercased = stringValue.lowercased()
            
            if lowercased == "t" || lowercased == "true" {
                return true
            } else if lowercased == "f" || lowercased == "false" {
                return false
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
