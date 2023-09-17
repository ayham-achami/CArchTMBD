//  
//  PersonRouter.swift
//  
//
//  Created by Ayham Hylam on 12.09.2023.
//

import CArch

/// Протокол организующий логику переходов от модуля `Person` в другие модули
protocol PersonRoutingLogic: RootRoutingLogic {}

/// Объект содержаний логику переходов от модуля `Person` в другие модули
final class PersonRouter: PersonRoutingLogic {
    
    private unowned let transitionController: TransitionController
    
    nonisolated init(transitionController: TransitionController) {
        self.transitionController = transitionController
    }
}