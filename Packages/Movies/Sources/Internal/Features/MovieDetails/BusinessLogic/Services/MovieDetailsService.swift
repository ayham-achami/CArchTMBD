//
//  MovieDetailsService.swift

import CArch
import CRest
import TMDBCore
import Foundation

// MAR: - DI
final class MovieDetailsServiceAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.record(MovieDetailsService.self, inScope: .autoRelease) { resolver in
            MovieDetailsServiceImplementation(io: resolver.unravel(ConcurrencyIO.self)!)
        }
    }
}

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
}

// MARK: - Public
@MaintenanceActor protocol MovieDetailsService: BusinessLogicService {
    
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
    
    private let io: ConcurrencyIO
    
    nonisolated init(io: ConcurrencyIO) {
        self.io = io
    }
    
    func fetchDetails(with id: Int) async throws -> MovieDetails {
        try await io.fetch(for: .details(id: id), response: MovieDetails.self, encoding: .URL(.default))
    }
    
    func fetchCast(with id: Int) async throws -> Credits {
        try await io.fetch(for: .cast(id: id), response: Credits.self, encoding: .URL(.default))
    }
}
