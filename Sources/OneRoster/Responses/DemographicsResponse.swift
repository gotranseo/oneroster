//
//  DemographicsResponse.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

/// See `DemographicData`
public struct DemographicsResponse: Codable {
    
    /// An array of `DemographicData` responses
    public let demographics: [DemographicData]
}
