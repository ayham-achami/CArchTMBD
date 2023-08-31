//
//  MoviesService.swift

import CArch
import TMDBCore
import Alamofire
import Foundation

final class MoviesServiceAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.record(MoviesService.self, inScope: .autoRelease) { resolver in
            MoviesServiceImplementation(resolver.unravel(JWTProvider.self)!)
        }
    }
}

public enum MoviesFetchError: Error {
    
    case response
    case invalidate(Int)
}

@MaintenanceActor public protocol MoviesService: BusinessLogicService {

    func fetchNowPlaying(_ page: Int) async throws -> Movies
    
    func fetchPopular(_ page: Int) async throws -> Movies
    
    func fetchTopRated(_ page: Int) async throws -> Movies
    
    func fetchUpcoming(_ page: Int) async throws -> Movies
}

private final class MoviesServiceImplementation: MoviesService {
    
    private let tokenProvider: JWTProvider
    private let baseURL = URL(string: "https://api.themoviedb.org/3/movie")!
    private let io: Session = { Session.default }()
    
    nonisolated init(_ tokenProvider: JWTProvider) {
        self.tokenProvider = tokenProvider
    }
    
    func fetchNowPlaying(_ page: Int) async throws -> Movies {
        let request = io.request(request(for: "now_playing", and: page))
        let result = await request
            .response(completionHandler: { print($0.debugDescription) })
            .validate(statusCode: 200...299)
            .serializingDecodable(Movies.self, decoder: JSONDecoder.default)
            .result
        switch result {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
    
    func fetchPopular(_ page: Int) async throws -> Movies {
        let request = io.request(request(for: "popular", and: page))
        let result = await request
            .response(completionHandler: { print($0.debugDescription) })
            .validate(statusCode: 200...299)
            .serializingDecodable(Movies.self, decoder: JSONDecoder.default)
            .result
        switch result {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
    
    func fetchTopRated(_ page: Int) async throws -> Movies {
        let request = io.request(request(for: "top_rated", and: page))
        let result = await request
            .response(completionHandler: { print($0.debugDescription) })
            .validate(statusCode: 200...299)
            .serializingDecodable(Movies.self, decoder: JSONDecoder.default)
            .result
        switch result {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
    
    func fetchUpcoming(_ page: Int) async throws -> Movies {
        let request = io.request(request(for: "upcoming", and: page))
        let result = await request
            .response(completionHandler: { print($0.debugDescription) })
            .validate(statusCode: 200...299)
            .serializingDecodable(Movies.self, decoder: JSONDecoder.default)
            .result
        switch result {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
    
    private func request(for path: String, and page: Int) -> URLRequest {
        let url = baseURL
            .appending(path: path)
            .appending(queryItems: [.init(name: "page", value: "\(page)")])
        var request = URLRequest(url: url,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(tokenProvider.token.access)"
        ]
        return request
    }
}
