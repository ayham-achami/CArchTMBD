//
//  MoviesService.swift

import CArch
import CRest
import TMDBCore
import Foundation

final class MoviesServiceAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.record(MoviesService.self, inScope: .autoRelease) { resolver in
            MoviesServiceImplementation(io: resolver.unravel(ConcurrencyIO.self)!)
        }
    }
}

private extension Request {
    
    enum Kind: String {
        
        case popular
        case upcoming
        case topRated = "top_rated"
        case nowPlaying = "now_playing"
    }
    
    static func movie(kind: Kind, at page: Int,
                      language: String? = nil,
                      region: String? = nil) -> Self {
        enum Keys: String, URLQueryKeys {
            
            case page
            case region
            case language
        }
        let url = DynamicURL
            .keyed(by: Keys.self)
            .with(endPoint: .movie)
            .with(pathComponent: kind.rawValue)
            .with(value: page, key: .page)
            .with(value: region, key: .region)
            .with(value: language, key: .language)
            .build()
        return .init(url)
    }
}

@MaintenanceActor protocol MoviesService: BusinessLogicService {

    func fetchNowPlaying(_ page: Int) async throws -> MoviesList
    
    func fetchPopular(_ page: Int) async throws -> MoviesList
    
    func fetchTopRated(_ page: Int) async throws -> MoviesList
    
    func fetchUpcoming(_ page: Int) async throws -> MoviesList
}

private final class MoviesServiceImplementation: MoviesService {
    
    private let io: ConcurrencyIO
    
    nonisolated init(io: ConcurrencyIO) {
        self.io = io
    }
    
    func fetchNowPlaying(_ page: Int) async throws -> MoviesList {
        try await io.fetch(for: .movie(kind: .nowPlaying, at: page), response: MoviesList.self, encoding: .URL(.default))
    }
    
    func fetchPopular(_ page: Int) async throws -> MoviesList {
        try await io.fetch(for: .movie(kind: .popular, at: page), response: MoviesList.self, encoding: .URL(.default))
    }
    
    func fetchTopRated(_ page: Int) async throws -> MoviesList {
        try await io.fetch(for: .movie(kind: .topRated, at: page), response: MoviesList.self, encoding: .URL(.default))
    }
    
    func fetchUpcoming(_ page: Int) async throws -> MoviesList {
        try await io.fetch(for: .movie(kind: .upcoming, at: page), response: MoviesList.self, encoding: .URL(.default))
    }
}
