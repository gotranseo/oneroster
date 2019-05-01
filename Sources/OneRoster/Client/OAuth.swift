//
//  OneRosterAPI.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation
import Crypto

struct OAuth {
    let clientId: String
    let clientSecret: String
    let baseUrl: String
    let endpoint: OneRosterAPI.Endpoint
    let limit: Int?
    let offset: Int?
    
    func generate() throws -> OAuthData {
        let url: String
        let parametersString: String?
        
        if baseUrl.hasSuffix("/") {
            url = "\(baseUrl)\(endpoint.endpoint)"
        } else {
            url = "\(baseUrl)/\(endpoint.endpoint)"
        }
        
        if let limit = limit, let offset = offset {
            parametersString = "?limit=\(limit)&offset=\(offset)"
        } else if let limit = limit {
            parametersString = "?limit=\(limit)"
        } else if let offset = offset {
            parametersString = "?offset=\(offset)"
        } else {
            parametersString = nil
        }
        
        let fullUrl = "\(url)\(parametersString ?? "")"
        
        // Create the OAuth 1.0 signature
        let httpVerb = "GET"
        let oauthConsumerKey = clientId
        let oauthNonce = UUID().uuidString
        let oauthSignatureMethod = "HMAC-SHA256"
        let oauthTimestamp = Date().timeIntervalSince1970
        let oauthVersion = "1.0"
        
        let oauthSignatureComponent = "\(limit == nil ? "" : "limit=\(limit!)&")oauth_consumer_key=\(oauthConsumerKey)&oauth_nonce=\(oauthNonce)&oauth_signature_method=\(oauthSignatureMethod)&oauth_timestamp=\(oauthTimestamp)&oauth_version=\(oauthVersion)\(offset == nil ? "" : "&offset=\(offset!)")"
        let oauthUnecryptedSignature = "\(httpVerb)&\(url.cleanUrl)&\(oauthSignatureComponent.cleanUrl)"
        
        let oauthSignature = try HMAC.SHA256.authenticate(oauthUnecryptedSignature.convertToData(), key: "\(clientSecret)&".convertToData()).base64EncodedString().cleanUrl
        
        let oauthHeaderString = #"OAuth oauth_consumer_key="\#(oauthConsumerKey)", oauth_nonce="\#(oauthNonce)", oauth_signature="\#(oauthSignature)", oauth_signature_method="\#(oauthSignatureMethod)", oauth_timestamp="\#(oauthTimestamp)", oauth_version="\#(oauthVersion)""#
        
        return OAuthData(oauthHeaderString: oauthHeaderString, signature: oauthSignature, fullUrl: fullUrl)
    }
}

struct OAuthData {
    let oauthHeaderString: String
    let signature: String
    let fullUrl: String
}
