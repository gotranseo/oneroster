//
//  Result.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

/// It is proposed that the OneRoster Result object takes a subset of the
/// equivalent LIS elements as shown in Figure 4.12/Table 4.11.
public struct Result: Codable, OneRosterBase {
    /// See `OneRosterBase.sourceId`
    public var sourcedId: String
    
    /// See `OneRosterBase.status`
    public var status: StatusType
    
    /// See `OneRosterBase.dateLastModified`
    public var dateLastModified: Date
    
    /// See `OneRosterBase.metadata`
    public var metadata: [String: String]?
    
    /// Link to lineItem i.e. the lineItem's 'sourcedId'.
    public var lineItem: GUIDRef
    
    /// Link to student i.e. the user's 'sourcedId'.
    public var student: GUIDRef
    
    /// See subsection 4.13.6 or `ScoreStatus` for the enumeration list.
    public var scoreStatus: ScoreStatus
    
    /// For example: 67.0
    public var score: Double
    
    /// For example: 2012-01-05
    public var scoreDate: Date
    
    /// For example: excellent
    public var comment: String?
}
