//
//  GUIDType.swift
//  OneRoster
//
//  Created by Jimmy McDermott on 3/25/19.
//

import Foundation

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
