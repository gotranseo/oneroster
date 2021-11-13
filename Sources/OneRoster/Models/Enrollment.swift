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

/// An enrollment is the name given to an individual taking part in a course or class.
/// In the vast majority of cases, users will be students learning in a class,
/// or teachers teaching the class. Other roles are also possible.
public struct Enrollment: Codable, OneRosterBase {
    /// See `OneRosterBase.sourceId`
    public var sourcedId: String
    
    /// See `OneRosterBase.status`
    public var status: StatusType
    
    /// See `OneRosterBase.dateLastModified`
    public var dateLastModified: String
    
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
    public var beginDate: String?
    
    /// The end date for the enrollment (exclusive). This date must be within the period of the
    /// associated Academic Session for the class (Term/Semester/SchoolYear).
    /// Example: 2013-03-31
    public var endDate: String?

    /// Create a new Enrollment
    public init(sourcedId: String,
                status: StatusType,
                dateLastModified: String,
                metadata: [String: String]?,
                user: GUIDRef,
                `class`: GUIDRef,
                school: GUIDRef,
                role: RoleType,
                primary: Bool?,
                beginDate: String?,
                endDate: String?)
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
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sourcedId = try values.decode(String.self, forKey: .sourcedId)
        status = try values.decode(StatusType.self, forKey: .status)
        dateLastModified = try values.decode(String.self, forKey: .dateLastModified)
        metadata = try values.decodeIfPresent(Dictionary.self, forKey: .metadata)
        user = try values.decode(GUIDRef.self, forKey: .user)
        `class` = try values.decode(GUIDRef.self, forKey: .class)
        school = try values.decode(GUIDRef.self, forKey: .school)
        role = try values.decode(RoleType.self, forKey: .role)
        primary = values.stringBooleanIfPresent(key: .primary)
        beginDate = try values.decodeIfPresent(String.self, forKey: .beginDate)
        endDate = try values.decodeIfPresent(String.self, forKey: .endDate)
    }
}
