//
//  AcademicSession.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

/// AcademicSession represent durations of time. Typically they are used to describe terms, grading periods, and other durations e.g. school years.
/// Term is used to describe a period of time during which learning will take place. Other words for term could be in common use around the world e.g.
/// Semester.
///
/// The important thing is that Term is a unit of time, often many weeks long, into which classes are scheduled. Grading Period is used to
/// represent another unit of time, that within which line items are assessed. A term may have many grading periods, a grading period belongs to a
/// single term. A class may be assessed over several grade periods (represented by a line item being connected to a grading period). The parent /
/// child attributes of academic sessions allow terms to be connected to their grading periods and vice-versa.
public struct AcademicSession: Codable, OneRosterBase {
    /// See `OneRosterBase.sourceId`
    public var sourcedId: String
    
    /// See `OneRosterBase.status`
    public var status: StatusType
    
    /// See `OneRosterBase.dateLastModified`
    public var dateLastModified: String
    
    /// See `OneRosterBase.metadata`
    public var metadata: [String: String]?
    
    /// For example: Spring Term
    public var title: String
    
    /// For example: 2012-01-01
    public var startDate: String
    
    /// For example: 2012-04-30
    public var endDate: String
    
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
                dateLastModified: String,
                metadata: [String: String]?,
                title: String,
                startDate: String,
                endDate: String,
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
