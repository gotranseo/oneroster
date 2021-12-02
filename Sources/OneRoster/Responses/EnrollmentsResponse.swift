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

/// See `Enrollment`
public struct EnrollmentsResponse: Codable, OneRosterResponse {
    /// The inner data type
    public typealias InnerType = Enrollment
    
    /// The key for the data
    public static var dataKey: DataKey? = \.enrollments
    
    /// An array of `Enrollment` responses
    public let enrollments: [Enrollment]
}
