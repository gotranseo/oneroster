//
//  EnrollmentResponse.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

/// See `Enrollment`
public struct EnrollmentResponse: Codable, OneRosterResponse {
    /// The inner data type
    public typealias InnerType = Enrollment
    
    /// The `Enrollment` response
    public let enrollment: InnerType
}
