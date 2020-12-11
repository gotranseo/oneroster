//
//  File.swift
//  
//
//  Created by Jimmy McDermott on 12/11/20.
//

import Foundation

/// See `Course`
public struct CoursesResponse: Codable, OneRosterResponse {
    /// The inner data type
    public typealias InnerType = Course

    /// The key for the data
    public static var dataKey: DataKey? = \.courses

    /// An array of `Course` responses
    public let courses: [Course]
}
