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
        container.record(some: AuthNavigator.self) { resolver in
            AuthNavigatorImplementation(resolver.unravel(some: FactoryProvider.self))
        }
    }
}

final class AuthNavigatorImplementation {
    
    private let factory: LayoutAssemblyFactory
    
    init(_ provider: FactoryProvider) {
        self.factory = provider.factory
    }
}

// MARK: - AuthNavigatorImplementation + AuthNavigator
extension AuthNavigatorImplementation: AuthNavigator {
    
    func destination(for bound: Auth.AuthBounds) -> TMDBCore.Destination {
        switch bound {
        case .login:
            return .init(MainModule.Builder(factory).build(), .main)
        }
    }
}
