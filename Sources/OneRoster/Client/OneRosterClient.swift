//
//  OneRosterClient.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

public struct OneRosterClient {
    public let baseUrl: String
    public let clientId: String
    public let clientSecret: String
    
    public init(baseUrl: String, clientId: String, clientSecret: String) {
        self.baseUrl = baseUrl
        self.clientId = clientId
        self.clientSecret = clientSecret
    }
}
