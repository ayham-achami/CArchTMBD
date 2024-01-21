//
//  PreviewsService.swift
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
            .with(endPoint: .reviews)
            .with(pathComponent: id)
            .with(value: language, key: .language)
            .build()
        return .init(url)
    }
}

// MARK: - Contract
@Contract protocol PreviewsService: BusinessLogicService, AutoResolve {
    
    func fetchReviews(for id: Int) async throws -> Reviews
}

// MARK: - Implementation
private actor PreviewsServiceImplementation: PreviewsService {
    
    private let io: ConcurrencyIO
    private let jwtProvider: JWTProvider
    
    init(io: ConcurrencyIO, jwtProvider: JWTProvider) {
        self.io = io
        self.jwtProvider = jwtProvider
    }
    
    init(_ resolver: DIResolver) {
        self.io = resolver.concurrencyIO
        self.jwtProvider = resolver.unravel(some: JWTController.self)
    }
    
    func fetchReviews(for id: Int) async throws -> Reviews {
        try await io.fetch(for: .details(id: id), response: Reviews.self, encoding: .URL(.default))
    }
}
