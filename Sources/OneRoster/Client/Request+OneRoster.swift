//
//  File.swift
//  
//
//  Created by Jimmy McDermott on 4/10/20.
//

import Foundation
import Vapor

extension Application {
    public var oneRoster: OneRosterClient {
        return OneRosterClient(client: self.client, logger: logger)
    }
}

extension Request {
    public var oneRoster: OneRosterClient {
        return OneRosterClient(client: self.client, logger: logger)
    }
}
