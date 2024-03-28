//
//  PersonRouter.swift
//

import CArch

/// Протокол организующий логику переходов от модуля `Person` в другие модули
protocol PersonRoutingLogic: RootRoutingLogic {
    
    /// Закрыть модуль
    func closeModule()
}

/// Объект содержаний логику переходов от модуля `Person` в другие модули
final class PersonRouter {
    
    private unowned let transitionController: TransitionController
    
    init(transitionController: TransitionController) {
        self.transitionController = transitionController
    }
}

// MARK: - PersonRouter + PersonRoutingLogic
extension PersonRouter: PersonRoutingLogic {
    
    @MainActor func closeModule() {
        transitionController.dismiss()
    }
}
