//
//  AppJWTController.swift
//  TMDB

import CArch
import CRest
import TMDBCore
import Foundation

final class AppJWTController: JWTController {
    
    var token: JWT {
        ("", "")
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

final class AppJWTControllerAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.record(JWTProvider.self, inScope: .autoRelease) { _ in
            AppJWTController()
        }
        container.record(JWTController.self, inScope: .autoRelease) { _ in
            AppJWTController()
        }
        container.record(BearerCredentialProvider.self, inScope: .autoRelease) { _ in
            AppJWTController()
        }
    }
}

