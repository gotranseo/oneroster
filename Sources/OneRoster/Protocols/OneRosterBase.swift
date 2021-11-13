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

/// Represents the base model that all OneRoster entities inherit from
public protocol OneRosterBase {
    /// For example: 9877728989-ABF-0001
    var sourcedId: String { get set }
    
    /// See subsection 4.13.8 for the enumeration list.
    var status: StatusType { get set }
    
    /// For example: 2012-04-23T18:25:43.511Z
    var dateLastModified: String { get set }
    
    /// Extra metadata from the OneRoster response
    var metadata: [String: String]? { get set }
}
