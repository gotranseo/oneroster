//
//  DemographicResponse.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

/// See `DemographicData`
public struct DemographicResponse: Codable, OneRosterResponse {
    /// The inner data type
    public typealias InnerType = DemographicData
    
    /// The `DemographicData` response
    public let demographic: InnerType
}
