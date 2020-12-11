//
//  Course.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

/// A Course is a course of study that, typically, has a shared curriculum although it may be taught to different
/// students by different teachers. It is likely that several classes of a single course may be taught in a term.
/// For example, a school runs Grade 9 English in the spring term. There are four classes, each with a different
/// 30 students, taught by 4 different teachers. However the curriculum for each of those four classes is the same
/// - the course curriculum.
public struct Course: Codable, OneRosterBase {
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
    
    /// Link to academicSessioni.e. the AcademicSession 'sourcedId'.
    public var schoolYear: GUIDRef?
    
    /// For example: CHEM101
    public var courseCode: String?
    
    /// Grade(s) for which the class is attended.
    public var grades: [Grade]?
    
    /// This is a human readable string. Example: "chemistry".
    public var subjects: [String]?
    
    /// This is a machine readable set of codes and the number should match the associated 'subjects' attribute.
    public var subjectCodes: [String]?
    
    /// Link to resources if applicable i.e. the 'sourcedIds'.
    public var resources: [GUIDRef]?

    /// Create a new `Course`
    public init(sourcedId: String,
                status: StatusType,
                dateLastModified: String,
                metadata: [String: String]?,
                title: String,
                schoolYear: GUIDRef?,
                courseCode: String?,
                grades: [Grade]?,
                subjects: [String]?,
                subjectCodes: [String]?,
                resources: [GUIDRef]?)
    {
        self.sourcedId = sourcedId
        self.status = status
        self.dateLastModified = dateLastModified
        self.metadata = metadata
        self.title = title
        self.schoolYear = schoolYear
        self.courseCode = courseCode
        self.grades = grades
        self.subjects = subjects
        self.subjectCodes = subjectCodes
        self.resources = resources
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sourcedId = try values.decode(String.self, forKey: .sourcedId)
        status = try values.decode(StatusType.self, forKey: .status)
        dateLastModified = try values.decode(String.self, forKey: .dateLastModified)
        metadata = try values.decodeIfPresent(Dictionary.self, forKey: .metadata)
        title = try values.decode(String.self, forKey: .title)
        schoolYear = (try? values.decodeIfPresent(GUIDRef.self, forKey: .schoolYear)) ?? nil
        courseCode = try values.decodeIfPresent(String.self, forKey: .courseCode)
        grades = (try? values.decodeIfPresent([Grade].self, forKey: .grades) ?? []) ?? []
        subjects = try values.decodeIfPresent([String].self, forKey: .subjects)
        subjectCodes = try values.decodeIfPresent([String].self, forKey: .subjectCodes)
        resources = try values.decodeIfPresent([GUIDRef].self, forKey: .resources)
    }
}
