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

/// The set of permitted tokens for the importance.
public enum Importance: String, Codable {
    /// A resource of primary usage.
    case primary
    
    /// A resource of secondary usage/significance.
    case secondary
}
