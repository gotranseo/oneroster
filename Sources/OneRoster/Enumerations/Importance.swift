//
//  Importance.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

/// The set of permitted tokens for the importance.
public enum Importance: String, Codable {
    
    /// A resource of primary usage.
    case primary
    
    /// A resource of secondary usage/significance.
    case secondary
}
