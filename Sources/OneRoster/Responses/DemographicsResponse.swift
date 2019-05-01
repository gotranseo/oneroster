//
//  DemographicsResponse.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

/// See `DemographicData`
public struct DemographicsResponse: Codable, OneRosterResponse {
    
    /// The inner data type
    public typealias InnerType = DemographicData
    
    /// The key for the data
    public static var dataKey: DataKey? = \.demographics
    
    /// An array of `DemographicData` responses
    public let demographics: [InnerType]
}
