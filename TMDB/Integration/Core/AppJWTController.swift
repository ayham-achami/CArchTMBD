//
//  AppJWTController.swift
//

import CArch
import CRest
import Foundation
import TMDBCore

final class AppJWTControllerAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.record(AppJWTController.self, inScope: .autoRelease, configuration: nil) { _ in
            AppJWTController()
        }
        container.record(JWTController.self, inScope: .autoRelease, configuration: nil) { resolver in
            resolver.unravel(some: AppJWTController.self)
        }
        container.record(JWTProvider.self, inScope: .autoRelease, configuration: nil) { resolver in
            resolver.unravel(some: AppJWTController.self)
        }
        container.record(BearerCredentialProvider.self, inScope: .autoRelease, configuration: nil) { resolver in
            resolver.unravel(some: AppJWTController.self)
        }
    }
}

final class AppJWTController: JWTController {
    
    var token: JWT {
        // swiftlint:disable:next line_length
        ("eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3NWQ4YTY1MDVkYmU2Y2NhODc5MmEwODJlNmI2ZDU2ZSIsInN1YiI6IjVjODE0NmY3YzNhMzY4NGU4ZmQ2M2E0ZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.-1fOBevFQKbPvFdbVs4zFDwHUJknj3644PHInA1tWSw", "")
    }
    
    var state: TMDBCore.AuthState {
        .guest
    }
    
    func set(_ token: JWT) throws {}
    
    func rest() {}
}

extension AppJWTController: BearerCredentialProvider {
    
    struct Credential: BearerCredential {
        
        var access: String
        var isValidated: Bool
    }
    
    var credential: BearerCredential {
        Credential(access: token.access, isValidated: true)
    }
    
    func refresh() async throws -> BearerCredential {
        credential
    }
}
