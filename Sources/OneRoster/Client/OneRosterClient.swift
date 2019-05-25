//
//  OneRosterClient.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation
import Crypto
import Vapor

public struct OneRosterClient: Service {
    public let client: Client

    public init(client: Client) {
        self.client = client
    }
    
    func decoder() -> JSONDecoder {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000'Z'"
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return jsonDecoder
    }
    
    public func requestMultiple<C: OneRosterResponse>(baseUrl: String,
                                                      clientId: String,
                                                      clientSecret: String,
                                                      endpoint: OneRosterAPI.Endpoint,
                                                      limit: Int = 100,
                                                      offset: Int = 0,
                                                      decoding: C.Type,
                                                      bypassRecursion: Bool = false) throws -> Future<[C.InnerType]>
    {
        
        guard let url = endpoint.fullUrl(baseUrl: baseUrl, limit: limit, offset: offset) else {
            return client.container.future(error: Abort(.internalServerError, reason: "Cannot generate URL"))
        }
        
        let oauthData = try OAuth(consumerKey: clientId,
                                  consumerSecret: clientSecret,
                                  url: url).generate()
        
        let headers: HTTPHeaders = [
            "Authorization": oauthData.oauthHeaderString
        ]
        
        let jsonDecoder = decoder()
        return client.get(url.absoluteString, headers: headers).flatMap { res in
            guard let data = res.http.body.data else { throw Abort(.internalServerError) }
            let totalEntityCount = Int(res.http.headers["x-total-count"].first ?? "") ?? 1
            let pageCountDouble = Double(totalEntityCount) / Double(limit)
            let pageCountInt = totalEntityCount / limit
            var pageCount = pageCountInt
            
            if pageCountDouble > Double(pageCountInt) {
                pageCount += 1
            }
            
            let entity = try jsonDecoder.decode(C.self, from: data)
            guard var array = entity.oneRosterDataKey else {
                throw Abort(.internalServerError, reason: "Wrong entity type to decode - no array found")
            }
            
            if !bypassRecursion {
                var futures = [Future<[C.InnerType]>]()
                for i in 1...pageCount {
                    let newOffset = i * limit
                    futures.append(try self.requestMultiple(baseUrl: baseUrl,
                                                            clientId: clientId,
                                                            clientSecret: clientSecret,
                                                            endpoint: endpoint,
                                                            limit: limit,
                                                            offset: newOffset,
                                                            decoding: decoding,
                                                            bypassRecursion: true))
                }
                
                return futures.flatten(on: self.client.container).map { new in
                    array.append(contentsOf: new.flatMap { $0 })
                    return array
                }
            } else {
                return self.client.container.future(array)
            }
        }
    }
    
    public func requestSingle<C: OneRosterResponse>(baseUrl: String,
                                                    clientId: String,
                                                    clientSecret: String,
                                                    endpoint: OneRosterAPI.Endpoint) throws -> Future<C>
    {
        guard let url = endpoint.fullUrl(baseUrl: baseUrl) else {
            return client.container.future(error: Abort(.internalServerError, reason: "Cannot generate URL"))
        }
        
        let oauthData = try OAuth(consumerKey: clientId,
                                  consumerSecret: clientSecret,
                                  url: url).generate()
        
        let headers: HTTPHeaders = [
            "Authorization": oauthData.oauthHeaderString
        ]
        
        let jsonDecoder = decoder()
        return client.get(url.absoluteString, headers: headers).map { res in
            guard let data = res.http.body.data else { throw Abort(.internalServerError) }
            return try jsonDecoder.decode(C.self, from: data)
        }
    }
}
