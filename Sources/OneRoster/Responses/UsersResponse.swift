//
//  UsersResponse.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

/// See `User`
public struct UsersResponse: Codable {
    
    /// An array of `User` responses
    public let users: [User]
}
