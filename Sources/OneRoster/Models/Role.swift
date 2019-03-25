//
//  Role.swift
//  OneRoster
//
//  Created by Jimmy McDermott on 3/24/19.
//

import Foundation

/// Represents an access level for a `User`
public enum Role: String, Codable {
    /// Administrator in the organization (e.g. School).
    case administrator
    
    /// Someone who provides appropriate aide to the user but NOT also one of the other roles.
    case aide
    
    /// Guardian of the user and NOT the Mother or Father. May also be a Relative.
    case guardian
    
    /// Mother or father of the user.
    case parent
    
    /// Exam proctor. Added in V1.1.
    case proctor
    
    /// A relative of the user and NOT the Mother or Father. May also be the Guardian.
    case relative
    
    /// A student at a organization (e.g. School).
    case student
    
    /// A Teacher at organization (e.g. School).
    case teacher
}
