//
//  AppJWTController.swift
//  TMDB

import CArch
import TMDBCore
import Foundation

final class AppJWTController: JWTController {
    
    var token: JWT {
         fatalError("Get TMBD auth key")
    }
    
    var state: TMDBCore.AuthState {
        .guest
    }
    
    func set(_ token: JWT) throws {}
    
    func rest() {}
}

final class AppJWTControllerAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.record(JWTProvider.self, inScope: .autoRelease) { _ in
            AppJWTController()
        }
        container.record(JWTController.self, inScope: .autoRelease) { _ in
            AppJWTController()
        }
    }
}

