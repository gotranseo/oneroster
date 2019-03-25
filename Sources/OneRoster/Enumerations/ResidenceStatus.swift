//
//  ResidenceStatus.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//


import Foundation

/// Defines the student's residence status.
/// Based on https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=20863
public enum ResidenceStatus: String, Codable {
    
    /// Resident of administrative unit and usual school attendance area
    case usualSchoolAttendanceArea = "01652"
    
    /// Resident of administrative unit, but of other school attendance area
    case otherSchoolAttendanceArea = "01653"
    
    /// Resident of this state, but not of this administrative unit
    case stateResidentNotAdminUnit = "01654"
    
    /// Resident of an administrative unit that crosses state boundaries
    case crossStateBoundaries = "01655"
    
    /// Resident of another state
    case otherStateResident = "01656"
}
