//
//  AuthNavigator.swift
//

import Auth
import CArch
import CArchSwinject
import Foundation
import TMDBCore

final class AuthNavigatorAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.record(AuthNavigator.self, inScope: .autoRelease, configuration: nil) { resolver in
            AuthNavigatorImplementation(resolver.unravel(some: FactoryProvider.self))
        }
    }
}

@MainActor final class AuthNavigatorImplementation: AuthNavigator {
    
    private let factory: LayoutAssemblyFactory
    
    nonisolated init(_ provider: FactoryProvider) {
        self.factory = provider.factory
    }
    
    func destination(for bound: Auth.AuthBounds) -> TMDBCore.Destination {
        switch bound {
        case .login:
            return .init(MainModule.Builder(factory).build(), .main)
        }
    }
}
