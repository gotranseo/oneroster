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

/// A Category is the name given to a grouping of line items.
/// (Line Items being equivalent to assignments which students will complete).
///
/// Examples of categories include "homework", "quizzes" or "essays". It is proposed that
/// the Category object be defined as shown in Figure 4.9/Table 4.8.
public struct LineItemCategory: Codable, OneRosterBase {
    /// See `OneRosterBase.sourceId`
    public var sourcedId: String
    
    /// See `OneRosterBase.status`
    public var status: StatusType
    
    /// See `OneRosterBase.dateLastModified`
    public var dateLastModified: String
    
    /// See `OneRosterBase.metadata`
    public var metadata: [String: String]?
    
    /// For example: Homework
    public var title: String

    /// Create a new `LineItemCategory`
    public init(sourcedId: String,
                status: StatusType,
                dateLastModified: String,
                metadata: [String: String]?,
                title: String)
    {
        self.sourcedId = sourcedId
        self.status = status
        self.dateLastModified = dateLastModified
        self.metadata = metadata
        self.title = title
    }
}
