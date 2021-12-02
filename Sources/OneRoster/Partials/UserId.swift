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

/// Represents an identifier for a user
public struct UserId: Codable {
    /// For example: LDAP
    public var type: String
    
    /// For example: 9877728989-ABF-0001
    public var identifier: String
    
    /// Creates a new UserId
    public init (type: String, identifier: String) {
        self.type = type
        self.identifier = identifier
    }
}
