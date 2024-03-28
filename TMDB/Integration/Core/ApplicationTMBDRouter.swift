//
//  ApplicationTMBDRouter.swift
//

import CArch
import CArchSwinject
import CFoundation
import TMDBCore
import UIKit

final class ApplicationTMBDRouterAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.record(some: ApplicationTMBDRouter.self) { resolver in
            ApplicationTMBDRouter(resolver.unravel(some: FactoryProvider.self))
        }
        container.record(some: ApplicationRouter.self) { resolver in
            resolver.unravel(some: ApplicationTMBDRouter.self)
        }
    }
}

final class ApplicationTMBDRouter {
    
    private let factory: LayoutAssemblyFactory
    
    init(_ provider: FactoryProvider) {
        self.factory = provider.factory
    }
}

// MARK: - ApplicationTMBDRouter + ApplicationRouter
extension ApplicationTMBDRouter: ApplicationRouter {
    
    @MainActor func show(_ destination: TMDBCore.Destination) {
        let secureRouter = SecureRouter()
        switch destination.level {
        case .main:
            secureRouter.unlock(with: destination.module)
        case .secure:
            secureRouter.lock(with: destination.module)
        }
    }
    
    @MainActor func showWelcome() {
        show(.init(WelcomeModule.NavigationBuilder(factory).build(), .secure))
    }
    
    @MainActor func showMain() {
        show(.init(MainModule.Builder(factory).build(), .main))
    }
}
