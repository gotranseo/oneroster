//
//  UsersResponse.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

/// See `User`
public struct UsersResponse: Codable, OneRosterResponse {
    /// The inner data type
    public typealias InnerType = User
    
    /// The key for the data
    public static var dataKey: DataKey? = \.users
    
    /// An array of `User` responses
    public let users: [InnerType]
}
