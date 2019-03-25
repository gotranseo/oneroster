//
//  Status.swift
//  OneRoster
//
//  Created by Jimmy McDermott on 3/24/19.
//

import Foundation

/// Represents the current status for the user
public enum Status: String, Codable {
    /// Currently Active
    case active
    
    /// User can safely be deleted
    case tobedeleted
    
    /// Maps to `tobedeleted`
    case inactive
}
