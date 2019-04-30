//
//  EnrollmentsResponse.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

/// See `Enrollment`
public struct EnrollmentsResponse: Codable {
    
    /// An array of `Enrollment` responses
    public let enrollments: [Enrollment]
}
