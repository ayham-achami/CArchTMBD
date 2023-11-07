//
//  PreviewsService.swift
//

import CArch
import CRest
import Foundation
import TMDBCore

// MARK: - DI
final class PreviewsServiceAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.recordService(PreviewsService.self) { resolver in
            PreviewsService(io: resolver.concurrencyIO,
                            jwtProvider: resolver.unravel(some: JWTProvider.self))
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
            .with(endPoint: .reviews)
            .with(pathComponent: id)
            .with(value: language, key: .language)
            .build()
        return .init(url)
    }
}

// MARK: - Service
actor PreviewsService: BusinessLogicService {
    
    private let io: ConcurrencyIO
    private let jwtProvider: JWTProvider
    
    init(io: ConcurrencyIO, jwtProvider: JWTProvider) {
        self.io = io
        self.jwtProvider = jwtProvider
    }
    
    func fetchReviews(for id: Int) async throws -> Reviews {
        try await io.fetch(for: .details(id: id), response: Reviews.self, encoding: .URL(.default))
    }
}
