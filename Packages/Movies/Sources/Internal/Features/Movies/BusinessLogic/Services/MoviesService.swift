//
//  MoviesService.swift
//

import CArch
import CRest
import Foundation
import TMDBCore

// MARK: Requests
private extension Request {
    
    enum Kind: String {
        
        case popular
        case upcoming
        case topRated = "top_rated"
        case nowPlaying = "now_playing"
    }
    
    static func movie(kind: Kind,
                      at page: Int,
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

// MARK: - Contract
@Contract protocol MoviesService: BusinessLogicService, AutoResolve {
    
    func fetchNowPlaying(_ page: Int) async throws -> MoviesList
    
    func fetchPopular(_ page: Int) async throws -> MoviesList
    
    func fetchTopRated(_ page: Int) async throws -> MoviesList
    
    func fetchUpcoming(_ page: Int) async throws -> MoviesList
}

// MARK: Implementation
private actor MoviesServiceImplementation: MoviesService {
    
    private let io: ConcurrencyIO
    
    init(io: ConcurrencyIO) {
        self.io = io
    }
    
    init(_ resolver: DIResolver) {
        self.io = resolver.concurrencyIO
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
