//
//  OrgType.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

/// The set of permitted tokens for the type of organization.
/// The explicit hierarchy is: national -> state -> local -> district -> school.
///
/// Note: A 'department' may be inserted below any entity other than national and above any entity other than national and state i.e. national -> state-> department -> local -> department -> district -> department -> school -> department.
public enum OrgType: String, Codable {
    
    /// Denotes a department. A department may be a subset in a school or a set of schools. Added in V1.1.
    case department
    
    /// Denotes a school. This is the unit of assignment for classes and enrollments.
    case school
    
    /// Denotes a school district. Added in V1.1.
    case district
    
    /// V1.0 instances will use this value to identify districts.
    case local
    
    /// Denotes a state level organization.
    case state
    
    /// Denotes a national level organization.
    case national
}
