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

/// Line Items are assignments in LIS, they make up the column headings in a gradebook,
/// and many students will each complete lineItems as they are assessed. It is proposed
/// that the Line Item object take a subset of the elements used in LIS, and adds a
/// few more which are relevant to K12.
public struct LineItem: Codable, OneRosterBase {
    /// See `OneRosterBase.sourceId`
    public var sourcedId: String
    
    /// See `OneRosterBase.status`
    public var status: StatusType
    
    /// See `OneRosterBase.dateLastModified`
    public var dateLastModified: String
    
    /// See `OneRosterBase.metadata`
    public var metadata: [String: String?]?
    
    /// For example: Maths Test 1
    public var title: String
    
    /// For example: Simple addition test
    public var description: String?
    
    /// For example: 2012-01-01T18:25:43.511Z
    public var assignDate: String
    
    /// For example: 2012-01-05T18:25:43.511Z
    public var dueDate: String
    
    /// Link to class i.e. the class 'sourcedId'.
    public var `class`: GUIDRef
    
    /// Link to item category i.e. the Line Item Category 'sourcedId'.
    public var category: GUIDRef
    
    /// Link to grading period i.e. the AcademicSession 'sourcedId'
    public var gradingPeriod: GUIDRef?
    
    /// A floating point number defining (inclusive) the minimum value for the result.
    /// For example: 0.0.
    public var resultValueMin: Double
    
    /// A floating point number defining (inclusive) the maximum value for the result.
    /// For example: 10.0
    public var resultValueMax: Double

    /// Create a new `LineItem`
    public init(sourcedId: String,
                status: StatusType,
                dateLastModified: String,
                metadata: [String: String]?,
                title: String,
                description: String?,
                assignDate: String,
                dueDate: String,
                `class`: GUIDRef,
                category: GUIDRef,
                gradingPeriod: GUIDRef?,
                resultValueMin: Double,
                resultValueMax: Double)
    {
        self.sourcedId = sourcedId
        self.status = status
        self.dateLastModified = dateLastModified
        self.metadata = metadata
        self.title = title
        self.description = description
        self.assignDate = assignDate
        self.dueDate = dueDate
        self.`class` = `class`
        self.category = category
        self.gradingPeriod = gradingPeriod
        self.resultValueMin = resultValueMin
        self.resultValueMax = resultValueMax
    }
}
