//
//  SchoolsResponse.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

/// See `Org`
public struct SchoolsResponse: Codable, OneRosterResponse {
    /// The inner data type
    public typealias InnerType = Org
    
    /// The key for the data
    public static var dataKey: DataKey? = \.orgs
    
    /// An array of `Org` responses
    public let orgs: [InnerType]
}
