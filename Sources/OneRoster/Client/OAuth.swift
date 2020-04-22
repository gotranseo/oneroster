//  Parts of this file are taken from OhhAuth. License included below:
//
//
//
//  Apache License, Version 2.0
//
//  Copyright 2017, Markus Wanke
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

/// # OhhAuth
/// ## Pure Swift implementation of the OAuth 1.0 protocol as an easy to use extension for the URLRequest type.
/// - Author: Markus Wanke
/// - Copyright: 2017

import Foundation
import Vapor

struct OAuth {
    let consumerKey: String
    let consumerSecret: String
    let url: URL
    let userKey: String?
    let userSecret: String?
    
    init(consumerKey: String, consumerSecret: String, url: URL, userKey: String? = nil, userSecret: String? = nil) {
        self.consumerKey = consumerKey
        self.consumerSecret = consumerSecret
        self.url = url
        self.userKey = userKey
        self.userSecret = userSecret
    }
    
    func generate(nonce: String? = nil, timestamp: Double? = nil, method: String = "GET") throws -> OAuthData {
        
        typealias Tup = (key: String, value: String)
        
        let tuplify: (String, String) -> Tup = {
            return (key: self.rfc3986encode($0), value: self.rfc3986encode($1))
        }
        
        let cmp: (Tup, Tup) -> Bool = {
            return $0.key < $1.key
        }
        
        let toPairString: (Tup) -> String = {
            return $0.key + "=" + $0.value
        }
        
        let toBrackyPairString: (Tup) -> String = {
            return $0.key + "=\"" + $0.value + "\""
        }
        
        /// [RFC-5849 Section 3.1](https://tools.ietf.org/html/rfc5849#section-3.1)
        let passedNonce = nonce ?? UUID().uuidString
        let signatureMethod = "HMAC-SHA256"
        let timestampString = timestamp == nil ? String(Int(Date().timeIntervalSince1970)) : String(timestamp!)
        var oAuthParameters = oAuthDefaultParameters(consumerKey: consumerKey,
                                                     signatureMethod: signatureMethod,
                                                     timestamp: timestampString,
                                                     userKey: userKey,
                                                     nonce: passedNonce)
        
        /// [RFC-5849 Section 3.4.1.3.1](https://tools.ietf.org/html/rfc5849#section-3.4.1.3.1)
        let signString: String = [oAuthParameters, url.queryParameters()]
            .flatMap { $0.map(tuplify) }
            .sorted(by: cmp)
            .map(toPairString)
            .joined(separator: "&")
        
        /// [RFC-5849 Section 3.4.1](https://tools.ietf.org/html/rfc5849#section-3.4.1)
        let signatureBase: String = [method, url.oAuthBaseURL(), signString]
            .map(rfc3986encode)
            .joined(separator: "&")
        
        /// [RFC-5849 Section 3.4.2](https://tools.ietf.org/html/rfc5849#section-3.4.2)
        let signingKey: String = [consumerSecret, userSecret ?? ""]
            .map(rfc3986encode)
            .joined(separator: "&")
        
        /// [RFC-5849 Section 3.4.2](https://tools.ietf.org/html/rfc5849#section-3.4.2)
        let binarySignature = HMAC<SHA256>.authenticationCode(for: Data(signatureBase.utf8), using: SymmetricKey(data: Data(signingKey.utf8)))
        oAuthParameters["oauth_signature"] = Data(binarySignature).base64EncodedString()
        
        let signatureHeader = "OAuth " + oAuthParameters
            .map(tuplify)
            .sorted(by: cmp)
            .map(toBrackyPairString)
            .joined(separator: ",")
        
        return OAuthData(oauthHeaderString: signatureHeader, signature: Data(binarySignature).base64EncodedString())
    }
    
    private func rfc3986encode(_ str: String) -> String {
        let allowed = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-._~"
        return str.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: allowed)) ?? str
    }
    
    private func oAuthDefaultParameters(consumerKey: String,
                                        signatureMethod: String,
                                        timestamp: String,
                                        userKey: String? = nil,
                                        nonce: String? = nil) -> [String: String]
    {
        /// [RFC-5849 Section 3.1](https://tools.ietf.org/html/rfc5849#section-3.1)
        var defaults: [String: String] = [
            "oauth_consumer_key": consumerKey,
            "oauth_signature_method": signatureMethod,
            "oauth_version": "1.0",
            "oauth_timestamp": timestamp,
            "oauth_nonce": nonce ?? UUID().uuidString,
        ]
        
        if let userKey = userKey {
            defaults["oauth_token"] = userKey
        }
        
        return defaults
    }
}

struct OAuthData {
    let oauthHeaderString: String
    let signature: String
}

extension URL {
    /// Transforms: "www.x.com?color=red&age=29" to ["color": "red", "age": "29"]
    func queryParameters() -> [String: String] {
        var res: [String: String] = [:]
        for qi in URLComponents(url: self, resolvingAgainstBaseURL: true)?.queryItems ?? [] {
            res[qi.name] = qi.value ?? ""
        }
        return res
    }
    
    func oAuthBaseURL() -> String {
        let scheme = self.scheme?.lowercased() ?? ""
        let host = self.host?.lowercased() ?? ""
        
        var authority = ""
        if let user = self.user, let pw = self.password {
            authority = user + ":" + pw + "@"
        }
        else if let user = self.user {
            authority = user + "@"
        }
        
        var port = ""
        if let iport = self.port, iport != 80, scheme == "http" {
            port = ":\(iport)"
        }
        else if let iport = self.port, iport != 443, scheme == "https" {
            port = ":\(iport)"
        }
        
        return scheme + "://" + authority + host + port + self.path
    }
}

extension OneRosterAPI.Endpoint {
    func fullUrl(baseUrl: String, limit: Int? = nil, offset: Int? = nil) -> URL? {
        let url: String
        let parametersString: String?
        
        if baseUrl.hasSuffix("/") {
            url = "\(baseUrl)\(self.endpoint)"
        } else {
            url = "\(baseUrl)/\(self.endpoint)"
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
        
        return URL(string: "\(url)\(parametersString ?? "")")
    }
}
