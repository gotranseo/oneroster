//
//  OneRosterClient.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation
import Crypto
import Vapor
import Logging

public struct OneRosterClient {
    public let client: Client
    public let logger: Logger
    
    public init(client: Client, logger: Logger) {
        self.client = client
        self.logger = logger
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
        self.logger.info("Starting requestMultiple function for \(baseUrl), limit: \(limit), offset: \(offset), endpoint: \(endpoint.endpoint)")
        guard let url = endpoint.fullUrl(baseUrl: baseUrl, limit: limit, offset: offset, filterString: filterString) else {
            self.logger.error("Cannot generate URL")
            return client.eventLoop.future(error: Abort(.internalServerError, reason: "Cannot generate URL"))
        }
        
        guard let oauthData = try? OAuth(consumerKey: clientId, consumerSecret: clientSecret, url: url).generate() else {
            self.logger.error("Cannot get OAuth data")
            return client.eventLoop.future(error: Abort(.internalServerError, reason: "Cannot get OAuth Data"))
        }
        
        let headers: HTTPHeaders = [
            "Authorization": oauthData.oauthHeaderString
        ]

        self.logger.info("Starting client.get call")
        let jsonDecoder = JSONDecoder()
        return client.get(URI(string: url.absoluteString), headers: headers) { _ in }.flatMap { res -> EventLoopFuture<[C.InnerType]> in
            guard let body = res.body else {
                self.logger.error("Cannot get response data")
                return self.client.eventLoop.future(error: Abort(.internalServerError))
            }

            let data = Data(body.readableBytesView)
            let totalEntityCount = Int(res.headers["x-total-count"].first ?? "") ?? 1
            let pageCountDouble = Double(totalEntityCount) / Double(limit)
            let pageCountInt = totalEntityCount / limit
            var pageCount = pageCountInt

            if pageCountDouble > Double(pageCountInt) {
                pageCount += 1
            }

            self.logger.info("totalEntityCount: \(totalEntityCount)")
            self.logger.info("pageCountDouble: \(pageCountDouble)")
            self.logger.info("pageCountInt: \(pageCountInt)")
            self.logger.info("pageCount: \(pageCount)")
            
            guard pageCount > 0 else {
                self.logger.info("Ending early - page count is \(pageCount)")
                return self.client.eventLoop.future([])
            }
            
            if let error = try? jsonDecoder.decode(OneRosterError.self, from: data) {
                let errorString = "OneRoster Error: \(error.errors.map { $0.description }.joined() )"
                self.logger.error("\(errorString)")
                return self
                    .client
                    .eventLoop
                    .future(error: Abort(.internalServerError, reason: errorString))
            } else {
                guard let entity = try? jsonDecoder.decode(C.self, from: data) else {
                    self.logger.error("Cannot decode data")
                    return self
                        .client
                        .eventLoop
                        .future(error: Abort(.internalServerError, reason: "Cannot decode data"))
                }
                
                guard var array = entity.oneRosterDataKey else {
                    self.logger.error("Wrong entity type to decode - no array found")
                    return self
                        .client
                        .eventLoop
                        .future(error: Abort(.internalServerError, reason: "Wrong entity type to decode - no array found"))
                }
                
                if !bypassRecursion {
                    var futures = [EventLoopFuture<[C.InnerType]>]()
                    for i in 1...pageCount {
                        let newOffset = i * limit
                        self.logger.info("Calling requestMultiple for newOffset: \(newOffset)")
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
                        self.logger.info("Done calling all futures")
                        array.append(contentsOf: new.flatMap { $0 })
                        return array
                    }
                } else {
                    self.logger.info("Returning array")
                    return self.client.eventLoop.future(array)
                }
            }
        }.map { finalData in
            self.logger.info("Final data returned: \(finalData.count)")
            return finalData
        }
    }
    
    public func requestSingle<C: OneRosterResponse>(baseUrl: String,
                                                    clientId: String,
                                                    clientSecret: String,
                                                    endpoint: OneRosterAPI.Endpoint,
                                                    filterString: String? = nil) throws -> EventLoopFuture<C>
    {
        self.logger.info("Starting requestSingle function for \(baseUrl), endpoint: \(endpoint.endpoint)")
        guard let url = endpoint.fullUrl(baseUrl: baseUrl, filterString: filterString) else {
            self.logger.error("Cannot generate URL")
            return client.eventLoop.future(error: Abort(.internalServerError, reason: "Cannot generate URL"))
        }
        
        guard let oauthData = try? OAuth(consumerKey: clientId, consumerSecret: clientSecret, url: url).generate() else {
            self.logger.error("Cannot get OAuth Data")
            return client.eventLoop.future(error: Abort(.internalServerError, reason: "Cannot get OAuth Data"))
        }
        
        let headers: HTTPHeaders = [
            "Authorization": oauthData.oauthHeaderString
        ]
        
        let jsonDecoder = JSONDecoder()
        return client.get(URI(string: url.absoluteString), headers: headers) { _ in }.flatMapThrowing { res in
            guard let body = res.body else {
                self.logger.error("Cannot get data")
                throw Abort(.internalServerError)
            }

            let data = Data(body.readableBytesView)
            return try jsonDecoder.decode(C.self, from: data)
        }
    }
}
