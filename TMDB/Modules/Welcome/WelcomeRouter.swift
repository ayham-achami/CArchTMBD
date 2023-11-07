//
//  WelcomeRouter.swift
//

import Auth
import CArch
import CArchSwinject
import Movies
import TMDBCore

/// Протокол организующий логику переходов от модуля `Welcome` в другие модули
protocol WelcomeRoutingLogic: RootRoutingLogic {
    
    func showMain(_ initialState: MoviesModuleState.InitialState)
    
    func showLogin(_ initialState: LoginModuleState.InitialState)
}

/// Объект содержаний логику переходов от модуля `Welcome` в другие модули
final class WelcomeRouter: WelcomeRoutingLogic {
    
    private let factoryProvider: FactoryProvider
    private unowned let transitionController: TransitionController
    
    nonisolated init(transitionController: TransitionController,
                     factoryProvider: FactoryProvider) {
        self.transitionController = transitionController
        self.factoryProvider = factoryProvider
    }
    
    func showMain(_ initialState: MoviesModuleState.InitialState) {
        TransitionBuilder
            .with(transitionController)
            .with(hierarchy: .clear)
            .with(transition: .push)
            .with(module: PackageStarterBuilder
                .with(factory: LayoutAssemblyFactory.self)
                .build(starter: MoviesPackageStarter.self)
                .clearMovies(initialState))
            .commit()
    }
    
    func showLogin(_ initialState: LoginModuleState.InitialState) {
        TransitionBuilder
            .with(transitionController)
            .with(hierarchy: .clear)
            .with(transition: .push)
            .with(module: PackageStarterBuilder
                .with(factory: LayoutAssemblyFactory.self)
                .build(starter: AuthPackageStarter.self)
                .login())
            .commit()
    }
}
