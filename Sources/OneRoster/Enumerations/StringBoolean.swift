//
//  StringBoolean.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

public enum StringBoolean: String, Codable {
    case `true` = "true"
    case `false` = "false"
    
    var bool: Bool {
        return self == .`true`
    }
}
