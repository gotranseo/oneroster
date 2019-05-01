//
//  OrgResponse.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

/// See `Org`
public struct OrgResponse: Codable, OneRosterResponse {
    /// The inner data type
    public typealias InnerType = Org
    
    /// The `Org` response
    public let org: InnerType
}
