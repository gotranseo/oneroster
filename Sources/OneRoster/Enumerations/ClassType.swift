//
//  ClassType.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

/// The set of permitted tokens for the type of class
public enum ClassType: String, Codable {
    
    /// The homeroom (form) assigned to the class.
    case homeroom
    
    /// The class as assigned in the timetable.
    case scheduled
}
