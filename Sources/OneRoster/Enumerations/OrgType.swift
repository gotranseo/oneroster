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
