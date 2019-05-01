//
//  StudentResponse.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

/// See `User`
public struct StudentResponse: Codable, OneRosterResponse {
    /// The inner data type
    public typealias InnerType = User
    
    /// The `User` response
    public let user: InnerType
}
