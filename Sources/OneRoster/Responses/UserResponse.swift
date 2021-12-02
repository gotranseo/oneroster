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
public struct UserResponse: Codable, OneRosterResponse {
    /// The inner data type
    public typealias InnerType = User
    
    /// The `User` response
    public let user: InnerType
}
