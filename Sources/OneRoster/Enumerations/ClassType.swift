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

/// The set of permitted tokens for the type of class
public enum ClassType: String, Codable {
    /// The homeroom (form) assigned to the class.
    case homeroom
    
    /// The class as assigned in the timetable.
    case scheduled
}
