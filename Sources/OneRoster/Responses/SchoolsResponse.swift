//
//  SchoolsResponse.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

/// See `Org`
public struct SchoolsResponse: Codable {
    
    /// An array of `Org` responses
    public let schools: [Org]
}
