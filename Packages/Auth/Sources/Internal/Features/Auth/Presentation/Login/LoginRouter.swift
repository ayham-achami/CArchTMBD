//
//  LoginRouter.swift

import CArch
import TMDBCore

/// Протокол организующий логику переходов от модуля `Login` в другие модули
protocol LoginRoutingLogic: RootRoutingLogic {
    
    /// Показать основной модуль
    func showMain()
}

/// Объект содержаний логику переходов от модуля `Login` в другие модули
final class LoginRouter: LoginRoutingLogic {
    
    private let authNavigator: AuthNavigator
    private let appRouter: ApplicationRouter
    private unowned let transitionController: TransitionController
    
    nonisolated init(transitionController: TransitionController,
                     appRouter: ApplicationRouter,
                     authNavigator: AuthNavigator) {
        self.appRouter = appRouter
        self.authNavigator = authNavigator
        self.transitionController = transitionController
    }
    
    func showMain() {
        appRouter.show(authNavigator.destination(for: .login))
    }
}
