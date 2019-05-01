//
//  EnrollmentsResponse.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

/// See `Enrollment`
public struct EnrollmentsResponse: Codable, OneRosterResponse {
    /// The inner data type
    public typealias InnerType = Enrollment
    
    /// The key for the data
    public static var dataKey: DataKey? = \.enrollments
    
    /// An array of `Enrollment` responses
    public let enrollments: [Enrollment]
}
