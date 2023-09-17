//
//  AuthNavigator.swift

import Auth
import CArch
import TMDBCore
import Foundation
import CArchSwinject

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

final class AuthNavigatorAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.record(AuthNavigator.self, inScope: .autoRelease) { resolver in
            AuthNavigatorImplementation(resolver.unravel(FactoryProvider.self)!)
        }
    }
}
