//
//  Resource.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

/// A resource is a description of learning content that is related to a course and/or a class.
/// This identifies a resource that is used by a teacher, learner, etc.
/// as part of the learning experience. A resource MUST be associated to a course and/or a class.
public struct Resource: Codable, OneRosterBase {
    /// See `OneRosterBase.sourceId`
    public var sourcedId: String
    
    /// See `OneRosterBase.status`
    public var status: StatusType
    
    /// See `OneRosterBase.dateLastModified`
    public var dateLastModified: String
    
    /// See `OneRosterBase.metadata`
    public var metadata: [String: String]?
    
    /// For example: Organic Chemistry
    public var title: String?
    
    /// The set of roles. See subsection 4.13.5 for the enumeration list.
    public var roles: [RoleType]?
    
    /// See subsection 4.13.3 or `Importance` for the enumeration list.
    public var importance: Importance?
    
    /// Unique identifier for the resource allocated by the vendor.
    public var vendorResourceId: String
    
    /// Identifier for the vendor who created the resource.
    /// This will be assigned by IMS as part of Conformance Certification.
    public var vendorId: String?
    
    /// Identifier for the application associated with the resource.
    public var applicationId: String?

    /// Create a new `Resource`
    public init(sourcedId: String,
                status: StatusType,
                dateLastModified: String,
                metadata: [String: String]?,
                title: String?,
                roles: [RoleType]?,
                importance: Importance?,
                vendorResourceId: String,
                vendorId: String?,
                applicationId: String?)
    {
        self.sourcedId = sourcedId
        self.status = status
        self.dateLastModified = dateLastModified
        self.metadata = metadata
        self.title = title
        self.roles = roles
        self.importance = importance
        self.vendorResourceId = vendorResourceId
        self.vendorId = vendorId
        self.applicationId = applicationId
    }
}
