//
//  File.swift
//  File
//
//  Created by James McDermott on 8/24/21.
//

import Foundation

/// See `Class`
public struct ClassesResponse: Codable, OneRosterResponse {
    /// The inner data type
    public typealias InnerType = Class

    /// The key for the data
    public static var dataKey: DataKey? = \.classes

    /// An array of `Course` responses
    public let classes: [Class]
}
