//  ___FILEHEADER___

import CArch

/// Протокол организующий логику переходов от модуля `___VARIABLE_productName___` в другие модули
protocol ___VARIABLE_productName___RoutingLogic: RootRoutingLogic {}

/// Объект содержаний логику переходов от модуля `___VARIABLE_productName___` в другие модули
final class ___VARIABLE_productName___Router: ___VARIABLE_productName___RoutingLogic {
    
    private unowned let transitionController: TransitionController
    
    nonisolated init(transitionController: TransitionController) {
        self.transitionController = transitionController
    }
}