//===----------------------------------------------------------------------===//
//
// This source file is part of the OneRoster open source project
//
// Copyright (c) 2021 the OneRoster project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

/// See `DemographicData`
public struct DemographicsResponse: Codable, OneRosterResponse {
    /// The inner data type
    public typealias InnerType = [DemographicData]
    
    /// The key for the data
    public static var dataKey: DataKey = \.demographics
    
    /// An array of `DemographicData` responses
    public let demographics: InnerType
}
