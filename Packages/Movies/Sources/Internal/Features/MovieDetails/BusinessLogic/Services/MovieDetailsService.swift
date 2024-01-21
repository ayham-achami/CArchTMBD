//
//  MovieDetailsService.swift
//

import CArch
import CRest
import Foundation
import TMDBCore

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

// MARK: - Contract
@Contract protocol MovieDetailsService: BusinessLogicService, AutoResolve {
    
    func fetchDetails(with id: Int) async throws -> MovieDetails
    
    func fetchCast(with id: Int) async throws -> Credits
    
    func fetchVideos(with id: Int) async throws -> Videos
}

// MARK: Implementation
private actor MovieDetailsServiceImplementation: MovieDetailsService {
    
    private let io: ConcurrencyIO
    
    init(io: ConcurrencyIO) {
        self.io = io
    }
    
    init(_ resolver: DIResolver) {
        self.io = resolver.concurrencyIO
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
