//
//  AuthService.swift
//

import CArch
import Foundation
import TMDBCore

// MARK: - Contract
@Contract protocol AuthService: BusinessLogicService, AutoResolve {
    
    func login(_ login: String, _ password: String) async throws
}

// MARK: - Implementation
private actor AuthServiceImplementation: AuthService {
    
    private let jwtController: JWTController
    
    init(jwtController: JWTController) {
        self.jwtController = jwtController
    }
    
    init(_ resolver: DIResolver) {
        self.jwtController = resolver.unravel(some: JWTController.self)
    }
    
    func login(_ login: String, _ password: String) async throws {
    }
}
