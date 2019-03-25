//
//  StatusType.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

/// Represents the current status for the user
public enum StatusType: String, Codable {
    /// Currently Active
    case active
    
    /// User can safely be deleted
    case tobedeleted
    
    /// Maps to `tobedeleted`
    case inactive
}
