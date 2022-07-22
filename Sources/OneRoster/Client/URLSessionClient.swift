import Vapor
import NIOCore
import Logging
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

internal struct URLSessionClient: Vapor.Client {
    let session: URLSession
    let eventLoop: EventLoop
    let logger: Logger
    
    static func shared(on eventLoop: EventLoop, logger: Logger) -> Client {
        URLSessionClient(session: .shared, eventLoop: eventLoop, logger: logger)
    }
    
    func delegating(to eventLoop: EventLoop) -> Client {
        URLSessionClient(session: self.session, eventLoop: eventLoop, logger: self.logger)
    }
    
    func logging(to logger: Logger) -> Client {
        URLSessionClient(session: self.session, eventLoop: self.eventLoop, logger: logger)
    }
    
    func send(_ request: ClientRequest) -> EventLoopFuture<ClientResponse> {
        guard let foundationUrl = URL(string: request.url.string) else {
            return self.eventLoop.makeFailedFuture(Abort(.internalServerError, reason: "Client request with invalid URL"))
        }
        
        var foundationRequest = URLRequest(url: foundationUrl)
        
        request.headers.forEach { foundationRequest.addValue($1, forHTTPHeaderField: $0) }
        foundationRequest.httpBody = request.body.map { Data($0.readableBytesView) }
        foundationRequest.httpMethod = request.method.string
        foundationRequest.cachePolicy = .reloadIgnoringLocalCacheData
        
        let promise = self.eventLoop.makePromise(of: ClientResponse.self)
        
        let dataTask = self.session.dataTask(with: foundationRequest, completionHandler: { data, response, error in
            if let error = error {
                return promise.fail(error)
            }
            guard let response = response as? HTTPURLResponse else {
                return promise.fail(Abort(.internalServerError, reason: "Client received no error but wrong kind of response"))
            }
            
            let clientResponse = ClientResponse(
                status: HTTPStatus(statusCode: response.statusCode),
                headers: .init(response.allHeaderFields.compactMapValues { $0 as? String }.compactMap { k, v in (k.base as? String).map { ($0, v) } }),
                body: data.map { .init(data: $0) }
            )
            return promise.succeed(clientResponse)
        })

        dataTask.resume()
        return promise.futureResult
    }
}

extension Application.Clients.Provider {
    public static var sharedUrlSession: Self {
        .init {
            $0.clients.use {
                URLSessionClient.shared(on: $0.eventLoopGroup.any(), logger: $0.logger)
            }
        }
    }
}

extension Application {
    public var sharedUrlSessionClient: Client {
        URLSessionClient.shared(on: self.eventLoopGroup.any(), logger: self.logger)
    }
}

extension Request {
    public var sharedUrlSessionClient: Client {
        URLSessionClient.shared(on: self.eventLoop, logger: self.logger)
    }
}
