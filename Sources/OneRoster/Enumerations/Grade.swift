//
//  Grade.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

/// See https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=7100
public enum Grade: String, Codable {
    /// Infant/Toddler
    case infantToddler = "IT"
    
    /// Pre-school
    case preSchool = "PR"
    
    /// Pre-kindergarten
    case preKindergarten = "PK"
    
    /// Transition Kindergarten
    case transitionalKindergarten = "TK"
    
    /// Kindergarten
    case kindergarten = "KG"
    
    /// First Grade
    case first = "01"
    
    /// Second Grade
    case second = "02"
    
    /// Third Grade
    case third = "03"
    
    /// Fourth Grade
    case fourth = "04"
    
    /// Fifth Grade
    case fifth = "05"
    
    /// Sixth Grade
    case sixth = "06"
    
    /// Seventh Grade
    case seventh = "07"
    
    /// Eighth Grade
    case eighth = "08"
    
    /// Ninth Grade
    case ninth = "09"
    
    /// Tenth Grade
    case tenth = "10"
    
    /// Eleventh Grade
    case eleventh = "11"
    
    /// Twelfth Grade
    case twelfth = "12"
    
    /// Thirteenth Grade
    case thirteenth = "13"
    
    /// Post-Secondary School
    case postSecondary = "PS"
    
    /// Ungraded
    case ungraded = "US"
    
    /// Other/Unknown
    case other = "Other"
}
