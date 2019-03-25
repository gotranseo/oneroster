//
//  GUIDRef.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

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
