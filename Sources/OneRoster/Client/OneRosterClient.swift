//
//  OneRosterClient.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation
import Crypto
import Vapor

public struct OneRosterClient {
    public let client: Client
    
    public init(client: Client) {
        self.client = client
    }
    
    public func requestMultiple<C: OneRosterResponse>(baseUrl: String,
                                                      clientId: String,
                                                      clientSecret: String,
                                                      endpoint: OneRosterAPI.Endpoint,
                                                      limit: Int = 100,
                                                      offset: Int = 0,
                                                      decoding: C.Type,
                                                      bypassRecursion: Bool = false,
                                                      filterString: String? = nil) -> EventLoopFuture<[C.InnerType]>
    {
        guard let url = endpoint.fullUrl(baseUrl: baseUrl, limit: limit, offset: offset, filterString: filterString) else {
            return client.eventLoop.future(error: Abort(.internalServerError, reason: "Cannot generate URL"))
        }
        
        guard let oauthData = try? OAuth(consumerKey: clientId, consumerSecret: clientSecret, url: url).generate() else {
            return client.eventLoop.future(error: Abort(.internalServerError, reason: "Cannot get OAuth Data"))
        }
        
        let headers: HTTPHeaders = [
            "Authorization": oauthData.oauthHeaderString
        ]
        
        let jsonDecoder = JSONDecoder()
        return client.get(URI(string: url.absoluteString), headers: headers) { _ in }.flatMap { res -> EventLoopFuture<[C.InnerType]> in
            guard let body = res.body else { return self.client.eventLoop.future(error: Abort(.internalServerError)) }
            let data = Data(body.readableBytesView)
            let totalEntityCount = Int(res.headers["x-total-count"].first ?? "") ?? 1
            let pageCountDouble = Double(totalEntityCount) / Double(limit)
            let pageCountInt = totalEntityCount / limit
            var pageCount = pageCountInt
            
            if pageCountDouble > Double(pageCountInt) {
                pageCount += 1
            }
            
            if let error = try? jsonDecoder.decode(OneRosterError.self, from: data) {
                return self
                    .client
                    .eventLoop
                    .future(error: Abort(.internalServerError, reason: "OneRoster Error: \(error.errors.map { $0.description }.joined() )"))
            } else {
                guard let entity = try? jsonDecoder.decode(C.self, from: data) else {
                    return self
                        .client
                        .eventLoop
                        .future(error: Abort(.internalServerError, reason: "Cannot decode data"))
                }
                
                guard var array = entity.oneRosterDataKey else {
                    return self
                        .client
                        .eventLoop
                        .future(error: Abort(.internalServerError, reason: "Wrong entity type to decode - no array found"))
                }
                
                if !bypassRecursion {
                    var futures = [EventLoopFuture<[C.InnerType]>]()
                    for i in 1...pageCount {
                        let newOffset = i * limit
                        futures.append(self.requestMultiple(baseUrl: baseUrl,
                                                            clientId: clientId,
                                                            clientSecret: clientSecret,
                                                            endpoint: endpoint,
                                                            limit: limit,
                                                            offset: newOffset,
                                                            decoding: decoding,
                                                            bypassRecursion: true))
                    }
                    
                    return futures.flatten(on: self.client.eventLoop).map { new in
                        array.append(contentsOf: new.flatMap { $0 })
                        return array
                    }
                } else {
                    return self.client.eventLoop.future(array)
                }
            }
        }
    }
    
    public func requestSingle<C: OneRosterResponse>(baseUrl: String,
                                                    clientId: String,
                                                    clientSecret: String,
                                                    endpoint: OneRosterAPI.Endpoint,
                                                    filterString: String? = nil) throws -> EventLoopFuture<C>
    {
        guard let url = endpoint.fullUrl(baseUrl: baseUrl, filterString: filterString) else {
            return client.eventLoop.future(error: Abort(.internalServerError, reason: "Cannot generate URL"))
        }
        
        guard let oauthData = try? OAuth(consumerKey: clientId, consumerSecret: clientSecret, url: url).generate() else {
            return client.eventLoop.future(error: Abort(.internalServerError, reason: "Cannot get OAuth Data"))
        }
        
        let headers: HTTPHeaders = [
            "Authorization": oauthData.oauthHeaderString
        ]
        
        let jsonDecoder = JSONDecoder()
        return client.get(URI(string: url.absoluteString), headers: headers) { _ in }.flatMapThrowing { res in
            guard let body = res.body else { throw Abort(.internalServerError) }
            let data = Data(body.readableBytesView)
            return try jsonDecoder.decode(C.self, from: data)
        }
    }
}
