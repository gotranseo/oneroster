//
//  SessionType.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

/// The set of permitted tokens for the type of academic session.
public enum SessionType: String, Codable {
    
    /// Denotes a period over which some grade/result is to be awarded.
    case gradingPeriod
    
    /// Denotes a semester period. Typically there a two semesters per schoolYear.
    case semester
    
    /// Denotes the school year.
    case schoolYear
    
    /// Denotes a term period. Typically there a three terms per schoolYear.
    case term
}
