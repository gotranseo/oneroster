//
//  User.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

/// Users, Teachers and Students are human beings that are teaching or studying in a class respectively.
/// LIS represents these with Person. For the case of binding, it is proposed that a single User class
/// is used to represent both teachers and students, and that a role element be used to distinguish a user's
/// natural role. In the rest binding to follow, it is possible to select teachers and students within a school,
/// course or class. In LIS, users have an "institution role" set within the person record to identify their
/// (primary) role.
///
/// Humans may have relationships with other humans. For example, a student may have parents. The "agents"
/// attribute allows for relationships between humans to be expressed. Note that these are typically from the
/// point of view of the student - so a student will link to its parents (via the agent attribute). The reverse
/// view MUST also be modeled, so for example, a user of role "parent" MUST have agents that are of type
/// "student".
public struct User: Codable, OneRosterBase {
    /// See `OneRosterBase.sourceId`
    public var sourcedId: String
    
    /// See `OneRosterBase.status`
    public var status: StatusType
    
    /// See `OneRosterBase.dateLastModified`
    public var dateLastModified: Date
    
    /// See `OneRosterBase.metadata`
    public var metadata: [String: String]?
    
    /// For example: pjn@imsglobal.org
    public var username: String
    
    /// This is the set of external user identifiers that should be used for this user, if for some reason the
    /// sourcedId cannot be used. This might be an active directory id, an LTI id, or some other machine-readable
    /// identifier that is used for this person.
    public var userIds: [UserId]
    
    /// 'false' denotes that the record is active but system access is curtailed
    /// according to the local administration rules. This field is used to determine
    /// whether or not the record is active in the local system.
    public var enabledUser: Bool
    
    /// For example: Phil
    public var givenName: String
    
    ///For example: Nicholls
    public var familyName: String
    
    /// If more than one middle name is needed separate using a space "Wingarde Granville"
    public var middleName: String?
    
    /// See subsection 4.13.6 for the enumeration list.
    public var role: RoleType
    
    /// For example: 9898-PJN
    public var identifier: String?
    
    /// For example: pjn@imsglobal.org
    public var email: String?
    
    /// For example: +44 07759 555 922
    public var sms: String?
    
    /// For example: +44 07759 555 922
    public var phone: String?
    
    /// Links to other people i.e. a User `sourcedId`
    public var agents: [GUIDRef]
    
    /// Links to orgs. In most cases, this is a single link to a school, but could be to a district or national
    /// org. People might also be linked to multiple organizations.
    public var orgs: [GUIDRef]
    
    /// Grade(s) for which a user with role 'student' is enrolled.
    public var grades: [Grade]
    
    /// For example: Xwyz//123
    public var password: String?

    /// Create a new User
    public init(sourcedId: String,
                status: StatusType,
                dateLastModified: Date,
                metadata: [String: String],
                username: String,
                userIds: [UserId],
                enabledUser: Bool,
                givenName: String,
                familyName: String,
                middleName: String?,
                role: RoleType,
                identifier: String?,
                email: String?,
                sms: String?,
                phone: String?,
                agents: [GUIDRef],
                orgs: [GUIDRef],
                grades: [Grade],
                password: String?)
    {
        self.sourcedId = sourcedId
        self.status = status
        self.dateLastModified = dateLastModified
        self.metadata = metadata
        self.username = username
        self.userIds = userIds
        self.enabledUser = enabledUser
        self.givenName = givenName
        self.familyName = familyName
        self.middleName = middleName
        self.role = role
        self.identifier = identifier
        self.email = email
        self.sms = sms
        self.phone = phone
        self.agents = agents
        self.orgs = orgs
        self.grades = grades
        self.password = password
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sourcedId = try values.decode(String.self, forKey: .sourcedId)
        status = try values.decode(StatusType.self, forKey: .status)
        dateLastModified = try values.decode(Date.self, forKey: .dateLastModified)
        metadata = try values.decodeIfPresent(Dictionary.self, forKey: .metadata)
        username = try values.decode(String.self, forKey: .username)
        userIds = try values.decode([UserId].self, forKey: .userIds)
        enabledUser = try values.stringBoolean(forKey: .enabledUser)
        givenName = try values.decode(String.self, forKey: .givenName)
        familyName = try values.decode(String.self, forKey: .familyName)
        middleName = try values.decodeIfPresent(String.self, forKey: .middleName)
        role = try values.decode(RoleType.self, forKey: .role)
        identifier = try values.decodeIfPresent(String.self, forKey: .identifier)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        sms = try values.decodeIfPresent(String.self, forKey: .sms)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        agents = try values.decode([GUIDRef].self, forKey: .agents)
        orgs = try values.decode([GUIDRef].self, forKey: .orgs)
        grades = try values.decode([Grade].self, forKey: .grades)
        password = try values.decodeIfPresent(String.self, forKey: .password)
    }
}
