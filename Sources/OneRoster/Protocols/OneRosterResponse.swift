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

public protocol OneRosterResponseData {}

extension Array: OneRosterResponseData where Element: OneRosterBase {}

public protocol OneRosterResponse: Codable {
    associatedtype InnerType: OneRosterResponseData
    typealias DataKey = KeyPath<Self, InnerType>
    
    static var dataKey: DataKey { get }
}

extension OneRosterResponse {
    public var oneRosterDataKey: InnerType {
        return self[keyPath: Self.dataKey]
    }
}
