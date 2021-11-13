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

/// Represents the current status for the user
public enum StatusType: String, Codable {
    /// Currently Active
    case active
    
    /// User can safely be deleted
    case tobedeleted
    
    /// Maps to `tobedeleted`
    case inactive
}
