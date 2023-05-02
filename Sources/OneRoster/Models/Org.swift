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

/// ORG is defined here as a structure for holding organizational information.
/// An ORG might be a school, or it might be a local, statewide, or national entity.
/// ORGs will typically have a parent ORG (up to the national level), and children,
/// allowing a hierarchy to be established.
///
/// School is defined here as the place where the learning happens. Most commonly this
/// is the data that describes a bricks and mortar building, or, in the case of a virtual school,
/// the virtual school organization. For enrollment and result reporting purposes, little information
/// about this organization is required. Later versions of the specification could add further information,
/// such as an address, for example. A common example of a local organization is a school district.
///
/// Note that although School is a type of org, the default entry point for requests in most places will be a school.
/// The API provides many school based entry points, whilst still allowing for more generic reading of ORGs,
/// for those applications that need to.
public struct Org: Codable, OneRosterBase {
    /// See `OneRosterBase.sourceId`
    public var sourcedId: String
    
    /// See `OneRosterBase.status`
    public var status: StatusType
    
    /// See `OneRosterBase.dateLastModified`
    public var dateLastModified: String
    
    /// See `OneRosterBase.metadata`
    public var metadata: [String: String?]?
    
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
                dateLastModified: String,
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
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sourcedId = try values.decode(String.self, forKey: .sourcedId)
        status = try values.decode(StatusType.self, forKey: .status)
        dateLastModified = try values.decode(String.self, forKey: .dateLastModified)
        metadata = try values.decodeIfPresent(Dictionary.self, forKey: .metadata)
        name = try values.decode(String.self, forKey: .name)
        type = try values.decode(OrgType.self, forKey: .type)
        identifier = try values.decodeIfPresent(String.self, forKey: .identifier)
        parent = (try? values.decodeIfPresent(GUIDRef.self, forKey: .parent)) ?? nil
        children = (try? values.decodeIfPresent([GUIDRef].self, forKey: .children)) ?? nil
    }
}
