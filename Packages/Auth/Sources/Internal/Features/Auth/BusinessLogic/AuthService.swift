//  
//  AuthService.swift

import CArch
import TMDBCore
import Foundation

// MARK: - DI
final class AuthServiceAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.recordService(AuthService.self) { resolver in
            AuthService(jwtController: resolver.unravel(some: JWTController.self))
        }
    }
}

// MARK: - Private
actor AuthService: BusinessLogicService {
    
    private let jwtController: JWTController
    
    init(jwtController: JWTController) {
        self.jwtController = jwtController
    }
    
    func login(_ login: String, _ password: String) async throws {        
    }
}
