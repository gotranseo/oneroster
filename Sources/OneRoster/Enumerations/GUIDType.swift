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

/// Describes the entity type of a returned GUIDRef
public enum GUIDType: String, Codable {
    /// An AcademicSession
    case academicSession
    
    /// A Cateogry
    case category
    
    /// A Class
    case `class`
    
    /// A Course
    case course
    
    /// Demographic Data
    case demographics
    
    /// Enrollment Data
    case enrollment
    
    /// A Grading Period
    case gradingPeriod
    
    /// A Line Item
    case lineItem
    
    /// An Organization
    case org
    
    /// A Resource
    case resource
    
    /// A Result
    case result
    
    /// A Student
    case student
    
    /// A Teacher
    case teacher
    
    /// A Term
    case term
    
    /// A User
    case user
}
