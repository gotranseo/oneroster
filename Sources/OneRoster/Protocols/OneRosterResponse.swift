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
