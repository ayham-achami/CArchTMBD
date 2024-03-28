//
//  ___VARIABLE_productName___Router.swift
//

import CArch

/// Протокол организующий логику переходов от модуля `___VARIABLE_productName___` в другие модули
protocol ___VARIABLE_productName___RoutingLogic: RootRoutingLogic {}

/// Объект содержаний логику переходов от модуля `___VARIABLE_productName___` в другие модули
final class ___VARIABLE_productName___Router {
    
    private unowned let transitionController: TransitionController
    
    init(transitionController: TransitionController) {
        self.transitionController = transitionController
    }
}

// MARK: - ___VARIABLE_productName___Router + ___VARIABLE_productName___RoutingLogic
extension ___VARIABLE_productName___Router: ___VARIABLE_productName___RoutingLogic {}
