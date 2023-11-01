//
//  MovieDetailsService.swift

import CArch
import CRest
import TMDBCore
import Foundation

// MARK: - DI
final class MovieDetailsServiceAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.recordService(MovieDetailsService.self) { resolver in
            MovieDetailsService(io: resolver.concurrencyIO)
        }
    }
}

// MARK: Requests
private extension Request {
    
    static func details(id: Int, language: String? = nil) -> Self {
        enum Keys: String, URLQueryKeys {
            
            case language
        }
        let url = DynamicURL
            .keyed(by: Keys.self)
            .with(endPoint: .movie)
            .with(pathComponent: id)
            .with(value: language, key: .language)
            .build()
        return .init(url)
    }
    
    static func cast(id: Int, language: String? = nil) -> Self {
        enum Keys: String, URLQueryKeys {
            
            case language
        }
        let url = DynamicURL
            .keyed(by: Keys.self)
            .with(endPoint: .movie)
            .with(pathComponent: "\(id)")
            .with(pathComponent: "credits")
            .with(value: language, key: .language)
            .build()
        return .init(url)
    }
    
    static func videos(id: Int, language: String? = nil) -> Self {
        enum Keys: String, URLQueryKeys {
            
            case language
        }
        let url = DynamicURL
            .keyed(by: Keys.self)
            .with(endPoint: .movie)
            .with(pathComponent: "\(id)")
            .with(pathComponent: "videos")
            .with(value: language, key: .language)
            .build()
        return .init(url)
    }
}

// MARK: Service
actor MovieDetailsService: BusinessLogicService {
    
    private let io: ConcurrencyIO
    
    init(io: ConcurrencyIO) {
        self.io = io
    }
    
    func fetchDetails(with id: Int) async throws -> MovieDetails {
        try await io.fetch(for: .details(id: id), response: MovieDetails.self, encoding: .URL(.default))
    }
    
    func fetchCast(with id: Int) async throws -> Credits {
        try await io.fetch(for: .cast(id: id), response: Credits.self, encoding: .URL(.default))
    }
    
    func fetchVideos(with id: Int) async throws -> Videos {
        try await io.fetch(for: .videos(id: id), response: Videos.self, encoding: .URL(.default))
    }
}
