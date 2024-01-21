//
//  PersonService.swift
//

import CArch
import CRest
import Foundation
import TMDBCore

// MARK: Requests
private extension Request {
 
    static func person(id: Int, language: String? = nil) -> Self {
        enum Keys: String, URLQueryKeys {
            
            case language
        }
        let url = DynamicURL
            .keyed(by: Keys.self)
            .with(endPoint: .person)
            .with(pathComponent: "\(id)")
            .with(value: language, key: .language)
            .build()
        return .init(url)
    }
    
    static func credits(id: Int, language: String? = nil) -> Self {
        enum Keys: String, URLQueryKeys {
            
            case language
        }
        let url = DynamicURL
            .keyed(by: Keys.self)
            .with(endPoint: .person)
            .with(pathComponent: "\(id)")
            .with(pathComponent: "movie_credits")
            .with(value: language, key: .language)
            .build()
        return .init(url)
    }
    
    static func images(id: Int) -> Self {
        .init(endPoint: .person, path: "\(id)/images")
    }
}

// MARK: - Public
@Contract protocol PersonService: BusinessLogicService, AutoResolve {
    
    func fetchPerson(with id: Int) async throws -> Person
    
    func fetchImages(with id: Int) async throws -> ProfileImages
    
    func fetchMovies(with id: Int) async throws -> ProfileMovies
}

// MARK: Service
private actor PersonServiceImplementation: PersonService {
    
    private let io: ConcurrencyIO
    
    init(io: ConcurrencyIO) {
        self.io = io
    }
    
    init(_ resolver: DIResolver) {
        self.io = resolver.concurrencyIO
    }
    
    func fetchPerson(with id: Int) async throws -> Person {
        try await io.fetch(for: .person(id: id), response: Person.self, encoding: .URL(.default))
    }
    
    func fetchImages(with id: Int) async throws -> ProfileImages {
        try await io.fetch(for: .images(id: id), response: ProfileImages.self, encoding: .URL(.default))
    }
    
    func fetchMovies(with id: Int) async throws -> ProfileMovies {
        try await io.fetch(for: .credits(id: id), response: ProfileMovies.self, encoding: .URL(.default))
    }
}
