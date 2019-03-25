//
//  AcademicSession.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

public struct AcademicSession: Codable, OneRosterBase {
    /// See `OneRosterBase.sourceId`
    public var sourcedId: String
    
    /// See `OneRosterBase.status`
    public var status: StatusType
    
    /// See `OneRosterBase.dateLastModified`
    public var dateLastModified: Date
    
    /// See `OneRosterBase.metadata`
    public var metadata: [String: String]?
    
    /// For example: Spring Term
    public var title: String
    
    /// For example: 2012-01-01
    public var startDate: Date
    
    /// For example: 2012-04-30
    public var endDate: Date
    
    /// See subsection 4.13.7 or `SessionType` for the enumeration list.
    public var type: SessionType
    
    /// Link to parent AcademicSession i.e. an AcademicSession 'sourcedId'.
    public var parent: GUIDRef?
    
    /// Links to children AcademicSession i.e. an AcademicSession 'sourcedId'.
    public var children: [GUIDRef]?
    
    /// The school year for the academic session. This year should include the school year end e.g. 2014.
    public var schoolYear: String

    /// Creates a new AcademicSession
    public init(sourcedId: String,
                status: StatusType,
                dateLastModified: Date,
                metadata: [String: String]?,
                title: String,
                startDate: Date,
                endDate: Date,
                type: SessionType,
                parent: GUIDRef?,
                children: [GUIDRef]?,
                schoolYear: String)
    {
        self.sourcedId = sourcedId
        self.status = status
        self.dateLastModified = dateLastModified
        self.metadata = metadata
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.type = type
        self.parent = parent
        self.children = children
        self.schoolYear = schoolYear
    }
}
