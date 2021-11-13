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

/// Represents a reference to another entity within the system
public struct GUIDRef: Codable {
    
    /// The link to the entity
    public let href: String
    
    /// The sourcedId. See `OpenRosterBase`.`sourcedId`
    public let sourcedId: String
    
    /// The type of the referenced entity
    public let type: GUIDType

    /// Create a new GUIDRef
    public init(href: String, sourcedId: String, type: GUIDType) {
        self.href = href
        self.sourcedId = sourcedId
        self.type = type
    }
}
