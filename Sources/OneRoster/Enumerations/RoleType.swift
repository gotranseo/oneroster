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

/// Represents an access level for a `User`
public enum RoleType: String, Codable {
    /// Administrator in the organization (e.g. School).
    case administrator
    
    /// Someone who provides appropriate aide to the user but NOT also one of the other roles.
    case aide
    
    /// Guardian of the user and NOT the Mother or Father. May also be a Relative.
    case guardian
    
    /// Mother or father of the user.
    case parent
    
    /// Exam proctor. Added in V1.1.
    case proctor
    
    /// A relative of the user and NOT the Mother or Father. May also be the Guardian.
    case relative
    
    /// A student at a organization (e.g. School).
    case student
    
    /// A Teacher at organization (e.g. School).
    case teacher
}
