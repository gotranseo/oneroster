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

/// See `User`
public struct StudentsResponse: Codable, OneRosterResponse {
    /// The inner data type
    public typealias InnerType = [User]
    
    /// The key for the data
    public static var dataKey: DataKey = \.users
    
    /// An array of `User` responses
    public let users: InnerType
}
