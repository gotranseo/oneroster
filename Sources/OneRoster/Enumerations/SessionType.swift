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

/// The set of permitted tokens for the type of academic session.
public enum SessionType: String, Codable {
    
    /// Denotes a period over which some grade/result is to be awarded.
    case gradingPeriod
    
    /// Denotes a semester period. Typically there a two semesters per schoolYear.
    case semester
    
    /// Denotes the school year.
    case schoolYear
    
    /// Denotes a term period. Typically there a three terms per schoolYear.
    case term
}
