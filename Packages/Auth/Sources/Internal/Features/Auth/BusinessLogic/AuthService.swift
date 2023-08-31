//  
//  AuthService.swift

import CArch
import TMDBCore
import Foundation

// MAR: - DI
final class AuthServiceAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.record(AuthService.self, inScope: .autoRelease) { resolver in
            AuthServiceImplementation(jwtController: resolver.unravel(JWTController.self)!)
        }
    }
}

// MARK: - Public
@MaintenanceActor public protocol AuthService: BusinessLogicService {
    
    func login(_ login: String, _ password: String) async throws
}

// MARK: - Private
private final class AuthServiceImplementation: AuthService {
    
    private let jwtController: JWTController
    
    nonisolated init(jwtController: JWTController) {
        self.jwtController = jwtController
    }
    
    func login(_ login: String, _ password: String) async throws {        
    }
}
