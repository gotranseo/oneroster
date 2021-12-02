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

import Vapor
import NIOHTTP1

public struct OneRosterErrorPayload: Codable {
    /// CodeMajor - specifies success or failure
    public enum CodeMajorPayload: String, Codable, CaseIterable {
        case success, failure
    }
    
    /// Severity - specifies importance
    public enum SeverityPayload: String, Codable, CaseIterable {
        case status, error, warning
    }
    
    /// CodeMinor - specifies a particular issue
    public enum CodeMinorPayload: Codable, RawRepresentable {
        case full_success, unknown_object, invalid_data, unauthorized, invalid_sort_field,
             invalid_filter_field, invalid_selection_field
        case custom(String)
        
        public var rawValue: String {
            switch self {
                case .full_success: return "full success"
                case .unknown_object: return "unknown object"
                case .invalid_data: return "invalid data"
                case .unauthorized: return "unauthorized"
                case .invalid_sort_field: return "invalid_sort_field"
                case .invalid_filter_field: return "invalid_filter_field"
                case .invalid_selection_field: return "invalid_selection_field"
                case .custom(let custom): return custom
            }
        }
        
        public init?(rawValue: String) {
            switch rawValue {
                case "full success": self = .full_success
                case "unknown object": self = .unknown_object
                case "invalid data": self = .invalid_data
                case "unauthorized": self = .unauthorized
                case "invalid_sort_field": self = .invalid_sort_field
                case "invalid_filter_field": self = .invalid_filter_field
                case "invalid_selection_field": self = .invalid_selection_field
                case let custom: self = .custom(custom)
            }
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            self = .init(rawValue: try container.decode(String.self))! // rawValue initializer always succeeds
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(self.rawValue)
        }
    }
    
    /// Success/failure indicator
    public let CodeMajor: CodeMajorPayload
    
    /// Condition importance indicator
    public let Severity: SeverityPayload
    
    /// Enumerated detail specifier
    public let CodeMinor: CodeMinorPayload
    
    /// Human-readable description
    public let Description: String
}

public struct OneRosterError: Error {
    public let status: HTTPResponseStatus
    public let payload: OneRosterErrorPayload?
    public let rawBody: ByteBuffer?
    
    public init(from clientResponse: ClientResponse) {
        self.status = clientResponse.status
        self.payload = try? clientResponse.content.decode(OneRosterErrorPayload.self)
        self.rawBody = clientResponse.body
    }
}
