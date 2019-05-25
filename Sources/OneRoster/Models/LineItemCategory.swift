//
//  LineItemCategory.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

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
