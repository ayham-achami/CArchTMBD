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
        self.factory = provider.factroy
    }
    
    nonisolated init() {
        self.factory = .init()
    }
    
    func show(_ destination: TMDBCore.Destination) {
        switch destination.level {
        case .main:
            if let module = secureQueue.dequeue() {
                secureRouter.unlock(with: module)
            } else {
                secureRouter.unlock(with: destination.module)
            }
        case .secure:
            if secureRouter.isLocked {
                secureQueue.enqueue(destination.module)
            } else {
                secureRouter.unlock(with: destination.module)
            }
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
        container.record(ApplicationRouter.self, inScope: .autoRelease) { resolver in
            ApplicationTMBDRouter(resolver.unravel(FactoryProvider.self)!)
        }
    }
}
