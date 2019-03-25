//
//  Enrollment.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

/// An enrollment is the name given to an individual taking part in a course or class.
/// In the vast majority of cases, users will be students learning in a class,
/// or teachers teaching the class. Other roles are also possible.
public struct Enrollment: Codable, OneRosterBase {
    /// See `OneRosterBase.sourceId`
    public var sourcedId: String
    
    /// See `OneRosterBase.status`
    public var status: StatusType
    
    /// See `OneRosterBase.dateLastModified`
    public var dateLastModified: Date
    
    /// See `OneRosterBase.metadata`
    public var metadata: [String: String]?
    
    /// Link to the enrolled User i.e. a User 'sourcedId'
    public var user: GUIDRef
    
    /// Link to the class on which the user is enrolled i.e. a Class 'sourcedId'
    public var `class`: GUIDRef
    
    /// Link to the school at which the class is being provided i.e. an Org 'sourcedId'
    public var school: GUIDRef
    
    /// See subsection 4.13.5 or `RoleType` for the enumeration list.
    public var role: RoleType
    
    /// Applicable only to teachers. Only one teacher should be designated as the primary teacher
    /// for a class in the period defined by the begin/end dates.
    public var primary: Bool?
    
    /// The start date for the enrollment (inclusive). This date must be within the period of the
    /// associated Academic Session for the class (Term/Semester/SchoolYear).
    /// Example: 2012-04-23
    public var beginDate: Date?
    
    /// The end date for the enrollment (exclusive). This date must be within the period of the
    /// associated Academic Session for the class (Term/Semester/SchoolYear).
    /// Example: 2013-03-31
    public var endDate: Date?

    /// Create a new Enrollment
    public init(sourcedId: String,
                status: StatusType,
                dateLastModified: Date,
                metadata: [String: String]?,
                user: GUIDRef,
                `class`: GUIDRef,
                school: GUIDRef,
                role: RoleType,
                primary: Bool?,
                beginDate: Date?,
                endDate: Date?)
    {
        self.sourcedId = sourcedId
        self.status = status
        self.dateLastModified = dateLastModified
        self.metadata = metadata
        self.user = user
        self.`class` = `class`
        self.school = school
        self.role = role
        self.primary = primary
        self.beginDate = beginDate
        self.endDate = endDate
    }
}
