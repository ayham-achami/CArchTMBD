//
//  ApplicationTMBDRouter.swift
//  TMDB

import CArch
import UIKit
import TMDBCore
import CFoundation
import CArchSwinject

@MainActor final class ApplicationTMBDRouter: ApplicationRouter {
    
    private let factory: LayoutAssemblyFactory
    
    private let secureRouter = SecureRouter()
    private var secureQueue = Queue<CArchModule>()
    
    nonisolated init(_ provider: FactoryProvider) {
        self.factory = provider.factory
    }
    
    func show(_ destination: TMDBCore.Destination) {
        switch destination.level {
        case .main:
            secureRouter.unlock(with: destination.module)
        case .secure:
            secureRouter.lock(with: destination.module)
        }
    }
    
    func showWelcome() {
        show(.init(WelcomeModule.NavigationBuilder(factory).build(), .secure))
    }
    
    func showMain() {
        show(.init(MainModule.Builder(factory).build(), .main))
    }
}

final class ApplicationTMBDRouterAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.record(ApplicationTMBDRouter.self, inScope: .autoRelease, configuration: nil) { resolver in
            ApplicationTMBDRouter(resolver.unravel(some: FactoryProvider.self))
        }
        container.record(ApplicationRouter.self, inScope: .autoRelease, configuration: nil) { resolver in
            resolver.unravel(some: ApplicationTMBDRouter.self)
        }
    }
}
