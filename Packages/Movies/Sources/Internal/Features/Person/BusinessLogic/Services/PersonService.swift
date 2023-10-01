//  
//  PersonService.swift

import CArch
import CRest
import TMDBCore
import Foundation

// MAR: - DI
final class PersonServiceAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.record(PersonService.self, inScope: .autoRelease) { resolver in
            PersonServiceImplementation(io: resolver.unravel(ConcurrencyIO.self)!)
        }
    }
}

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
@MaintenanceActor protocol PersonService: BusinessLogicService {
    
    func fetchPerson(with id: Int) async throws -> Person
    
    func fetchImages(with id: Int) async throws -> ProfileImages
    
    func fetchMovies(with id: Int) async throws -> ProfileMovies
}

// MARK: - Private
private final class PersonServiceImplementation: PersonService {
    
    private let io: ConcurrencyIO
    
    nonisolated init(io: ConcurrencyIO) {
        self.io = io
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
