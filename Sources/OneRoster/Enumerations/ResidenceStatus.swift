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
