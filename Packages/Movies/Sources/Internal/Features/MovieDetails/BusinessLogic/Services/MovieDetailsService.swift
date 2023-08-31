//
//  MovieDetailsService.swift

import CArch
import TMDBCore
import Alamofire
import Foundation

// MAR: - DI
final class MovieDetailsServiceAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.record(MovieDetailsService.self, inScope: .autoRelease) { resolver in
            MovieDetailsServiceImplementation(resolver.unravel(JWTProvider.self)!)
        }
    }
}

// MARK: - Public
@MaintenanceActor public protocol MovieDetailsService: BusinessLogicService {
    
    /// <#Description#>
    /// - Parameter id: <#id description#>
    /// - Returns: <#description#>
    func fetchDetails(with id: Int) async throws -> MovieDetails
    
    /// <#Description#>
    /// - Parameter id: <#id description#>
    /// - Returns: <#description#>
    func fetchCast(with id: Int) async throws -> Credits
}

// MARK: - Private
private final class MovieDetailsServiceImplementation: MovieDetailsService {
    
    private let tokenProvider: JWTProvider
    private let io: Session = { Session.default }()
    private let baseURL = URL(string: "https://api.themoviedb.org/3/movie")!
    private lazy var headers = ["accept": "application/json", "Authorization": "Bearer \(tokenProvider.token.access)"]
    
    nonisolated init(_ tokenProvider: JWTProvider) {
        self.tokenProvider = tokenProvider
    }
    
    func fetchDetails(with id: Int) async throws -> MovieDetails {
        let url = baseURL
            .appending(path: "\(id)")
        var request = URLRequest(url: url,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let result = await io.request(request)
            .response(completionHandler: { print($0.debugDescription) })
            .validate(statusCode: 200...299)
            .serializingDecodable(MovieDetails.self, decoder: JSONDecoder.default)
            .result
        switch result {
        case .success(let response):
            return response
        case .failure(let error):
            print(error)
            throw error
        }
    }
    
    func fetchCast(with id: Int) async throws -> Credits {
        let url = baseURL
            .appending(path: "\(id)")
            .appending(path: "credits")
            .appending(queryItems: [.init(name: "language", value: "ru")])
        var request = URLRequest(url: url,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let result = await io.request(request)
            .validate(statusCode: 200...299)
            .serializingDecodable(Credits.self, decoder: JSONDecoder.default)
            .result
        switch result {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
}
