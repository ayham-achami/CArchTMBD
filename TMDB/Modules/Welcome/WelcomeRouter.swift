//
//  WelcomeRouter.swift
//  TMDB

import Auth
import CArch
import TMDBCore
import CArchSwinject

/// Протокол организующий логику переходов от модуля `Welcome` в другие модули
protocol WelcomeRoutingLogic: RootRoutingLogic {
    
    func showMain(_ initialState: MainModuleState.InitialState)
    
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
    
    func showMain(_ initialState: MainModuleState.InitialState) {
        TransitionBuilder
            .with(transitionController)
            .with(hierarchy: .clear)
            .with(transition: .push)
            .with(state: initialState)
            .with(module: MainModule.Builder(factoryProvider.factroy).build())
            .commit()
    }
    
    func showLogin(_ initialState: LoginModuleState.InitialState) {
        TransitionBuilder
            .with(transitionController)
            .with(hierarchy: .clear)
            .with(transition: .push)
            .with(module: PackegeStarterBuilder.with(factory: LayoutAssemblyFactory.self).build(starter: AuthPackegeStarter.self).login())
            .commit()
    }
}
