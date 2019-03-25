//
//  OneRosterBase.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

/// Represents the base model that all OneRoster entities inherit from
public protocol OneRosterBase {
    /// For example: 9877728989-ABF-0001
    var sourcedId: String { get set }
    
    /// See subsection 4.13.8 for the enumeration list.
    var status: StatusType { get set }
    
    /// For example: 2012-04-23T18:25:43.511Z
    var dateLastModified: Date { get set }
    
    /// Extra metadata from the OneRoster response
    var metadata: [String: String] { get set }
}
