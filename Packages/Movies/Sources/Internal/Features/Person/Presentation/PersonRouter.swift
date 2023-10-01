//  
//  PersonRouter.swift

import CArch

/// Протокол организующий логику переходов от модуля `Person` в другие модули
protocol PersonRoutingLogic: RootRoutingLogic {
    
    /// Закрыть модуль
    func closeModule()
}

/// Объект содержаний логику переходов от модуля `Person` в другие модули
final class PersonRouter: PersonRoutingLogic {
    
    private unowned let transitionController: TransitionController
    
    nonisolated init(transitionController: TransitionController) {
        self.transitionController = transitionController
    }
    
    func closeModule() {
        transitionController.dismiss()
    }
}
