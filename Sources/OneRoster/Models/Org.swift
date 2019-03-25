//
//  Org.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

public struct Org: Codable, OneRosterBase {
    /// See `OneRosterBase.sourceId`
    public var sourcedId: String
    
    /// See `OneRosterBase.status`
    public var status: StatusType
    
    /// See `OneRosterBase.dateLastModified`
    public var dateLastModified: Date
    
    /// See `OneRosterBase.metadata`
    public var metadata: [String: String]?
    
    /// For example: IMS High
    public var name: String
    
    /// See Subsection 4.13.4 or `OrgType` for enumeration list.
    public var type: OrgType
    
    /// Human readable identifier for this org (e.g. NCES ID).
    public var identifier: String?
    
    /// Link to Org i.e. the parent Org 'sourcedId'
    public var parent: GUIDRef?
    
    /// Link to Org i.e. the child Org 'sourcedId'.
    public var children: [GUIDRef]?

    /// Create a new `Org`
    public init(sourcedId: String,
                status: StatusType,
                dateLastModified: Date,
                metadata: [String: String]?,
                name: String,
                type: OrgType,
                identifier: String?,
                parent: GUIDRef?,
                children: [GUIDRef]?)
    {
        self.sourcedId = sourcedId
        self.status = status
        self.dateLastModified = dateLastModified
        self.metadata = metadata
        self.name = name
        self.type = type
        self.identifier = identifier
        self.parent = parent
        self.children = children
    }
}
