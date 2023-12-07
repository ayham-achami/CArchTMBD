//
//  REST.swift
//

import CArch
import CArchSwinject
import CFoundation
import CRest
import Foundation

// swiftlint:disable file_types_order
extension Logger: NetworkLogger {}

@frozen public struct IOConfiguration: RestIOConfiguration {
    
    #if DEBUG
    public let informant: NetworkInformant = .init(logger: Logger(level: .debug))
    #else
    public let informant: NetworkInformant = .init(logger: Logger(level: .release))
    #endif
    public let allHostsMustBeEvaluated: Bool = false
    
    public init() {}
}

@frozen public struct RestError: ServerError, Response {
    
    public enum CodingKeys: String, CodingKey {
        
        case success
        case code = "statusCode"
        case message = "statusMessage"
    }
    
    public let code: Int
    public let success: Bool
    public let message: String
}

@frozen public struct APIError: LocalizedError {
    
    public let httpCode: Int
    public let rest: RestError
    
    public var errorDescription: String? {
        rest.message
    }
    
    public init(httpCode: Int, rest: RestError) {
        self.httpCode = httpCode
        self.rest = rest
    }
}

public extension AsyncAlamofireRestIO {
    
    var authenticator: IOBearerAuthenticator {
        LayoutAssemblyFactory().resolver.unravel(some: IOBearerAuthenticator.self)
    }
    
    var builder: DynamicRequest.Builder {
        .init()
        .with(encoder: .default)
        .with(decoder: .default)
        .with(interceptors: [authenticator])
    }
}

extension AsyncAlamofireRestIO: AsyncRestIOSendable {
    
    public func send<Response, Parameters>(for request: CRest.Request,
                                           parameters: Parameters?,
                                           response: Response.Type,
                                           method: CRest.Http.Method,
                                           encoding: CRest.Http.Encoding) async throws -> Response where Response: CRest.Response, Parameters: CRest.Parameters {
        let request = try builder
            .with(url: request.rawValue)
            .with(method: method)
            .with(encoding: encoding)
            .with(parameters: parameters)
            .build()
        do {
            return try await perform(request, response: response)
        } catch let NetworkError.http(code, data) {
            guard let data else { throw NetworkError.http(code) }
            let restError: RestError
            do {
                restError = try JSONDecoder.default.decode(RestError.self, from: data)
            } catch {
                throw NetworkError.http(code)
            }
            throw APIError(httpCode: code, rest: restError)
        } catch {
            throw error
        }
    }
}

public typealias ConcurrencyIO = AsyncRestIO & AsyncRestIOSendable

extension AsyncAlamofireRestIO: BusinessLogicEngine {}

public final class RestIOAssembly: DIAssembly {
    
    public init() {}
    
    public func assemble(container: DIContainer) {
        container.recordEngine(AsyncAlamofireRestIO.self) { _ in
            AsyncAlamofireRestIO(IOConfiguration())
        }
    }
}

public extension DIResolver {
    
    var concurrencyIO: ConcurrencyIO {
        unravelEngine(AsyncAlamofireRestIO.self)
    }
}
// swiftlint:enable file_types_order
