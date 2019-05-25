//
//  OneRosterError.swift
//  OneRoster
//
//  Created by Jimmy McDermott on 5/25/19.
//

import Foundation

public struct OneRosterError: Codable {
    let errors: [Error]
    
    public struct Error: Codable {
        public let description: String
    }
}
