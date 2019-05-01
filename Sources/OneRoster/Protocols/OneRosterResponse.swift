//
//  OneRosterResponse.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

public protocol OneRosterResponse: Codable {
    associatedtype InnerType: OneRosterBase
    typealias DataKey = KeyPath<Self, Array<InnerType>>
    
    static var dataKey: DataKey? { get }
}

extension OneRosterResponse {
    public static var dataKey: DataKey? {
        return nil
    }
    
    public var oneRosterDataKey: Array<InnerType>? {
        get {
            guard let key = Self.dataKey else {
                return nil
            }
            return self[keyPath: key]
        }
    }
}
