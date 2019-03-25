//
//  UserId.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

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
