//
//  Class.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

/// A class is an instance of a course, onto which students and teachers are enrolled.
/// A class is typically held within a term.
public struct Class: Codable, OneRosterBase {
    /// See `OneRosterBase.sourceId`
    public var sourcedId: String
    
    /// See `OneRosterBase.status`
    public var status: StatusType
    
    /// See `OneRosterBase.dateLastModified`
    public var dateLastModified: String
    
    /// See `OneRosterBase.metadata`
    public var metadata: [String: String]?
    
    /// For example: Basic Chemistry
    public var title: String
    
    /// For example: Chem101-Mr Rogers
    public var classCode: String?
    
    /// For example: "room 19"
    public var location: String?
    
    /// Grade(s) for which the class is attended.
    public var grades: [Grade]?
    
    /// Subject name(s). Example: "chemistry"
    public var subjects: [String]?
    
    /// Link to course i.e. the Course 'sourcedId'.
    public var course: GUIDRef
    
    /// Link to school i.e. the School 'sourcedId'.
    public var school: GUIDRef
    
    /// Links to terms or semesters (academicSession) i.e. the set of 'sourcedIds' for the terms within
    /// the associated school year.
    public var terms: [GUIDRef]
    
    /// This is a machine readable set of codes and the number should match the associated 'subjects' attribute.
    public var subjectCodes: [String]?
    
    /// The time slots in the day that the class will be given. Examples: 1 or an array of 1, 3, 5, etc.
    public var periods: [String]?
    
    /// Link to resources i.e. the Resource 'sourcedId'.
    public var resources: [GUIDRef]?

    /// Create a new `Class`
    public init(sourcedId: String,
                status: StatusType,
                dateLastModified: String,
                metadata: [String: String]?,
                title: String,
                classCode: String?,
                location: String?,
                grades: [Grade]?,
                subjects: [String]?,
                course: GUIDRef,
                school: GUIDRef,
                terms: [GUIDRef],
                subjectCodes: [String]?,
                periods: [String]?,
                resources: [GUIDRef]?)
    {
        self.sourcedId = sourcedId
        self.status = status
        self.dateLastModified = dateLastModified
        self.metadata = metadata
        self.title = title
        self.classCode = classCode
        self.location = location
        self.grades = grades
        self.subjects = subjects
        self.course = course
        self.school = school
        self.terms = terms
        self.subjectCodes = subjectCodes
        self.periods = periods
        self.resources = resources
    }
}
