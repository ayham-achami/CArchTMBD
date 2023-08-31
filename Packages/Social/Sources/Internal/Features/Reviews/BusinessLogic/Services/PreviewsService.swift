//  
//  PreviewsService.swift
//  TMDB

import CArch
import TMDBCore
import Alamofire
import Foundation

// MAR: - DI
final class PreviewsServiceAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.record(PreviewsService.self, inScope: .autoRelease) { resolver in
            PreviewsServiceImplementation(resolver.unravel(JWTProvider.self)!)
        }
    }
}

// MARK: - Public
@MaintenanceActor public protocol PreviewsService: BusinessLogicService {
    
    /// <#Description#>
    /// - Parameter id: <#id description#>
    /// - Returns: <#description#>
    func fetchReviews(for id: Int) async throws -> Reviews
}

// MARK: - Private
private final class PreviewsServiceImplementation: PreviewsService {
    
    private let jwtProvider: JWTProvider
    private let io: Session = { Session.default }()
    private let baseURL = URL(string: "https://api.themoviedb.org/3/movie")!
    private lazy var headers = ["accept": "application/json", "Authorization": "Bearer \(jwtProvider.token.access)"]
    
    nonisolated init(_ jwtProvider: JWTProvider) {
        self.jwtProvider = jwtProvider
    }
    
    func fetchReviews(for id: Int) async throws -> Reviews {
        let url = baseURL
            .appending(path: "\(id)")
            .appending(path: "reviews")
        var request = URLRequest(url: url,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let result = await io.request(request)
            .response(completionHandler: { print($0.debugDescription) })
            .validate(statusCode: 200...299)
            .serializingDecodable(Reviews.self, decoder: JSONDecoder.default)
            .result
        switch result {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
}
