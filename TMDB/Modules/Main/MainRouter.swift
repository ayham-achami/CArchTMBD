//
//  MainRouter.swift
//

import CArch

/// Протокол организующий логику переходов от модуля `Main` в другие модули
protocol MainRoutingLogic: RootRoutingLogic {}

/// Объект содержаний логику переходов от модуля `Main` в другие модули
final class MainRouter {
    
    private unowned let transitionController: TransitionController
    
    init(transitionController: TransitionController) {
        self.transitionController = transitionController
    }
}

// MARK: - MainRouter + MainRoutingLogic
extension MainRouter: MainRoutingLogic {}
