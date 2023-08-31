//  
//  MovieDetailsRouter.swift

import CArch

/// Протокол организующий логику переходов от модуля `MovieDetails` в другие модули
protocol MovieDetailsRoutingLogic: RootRoutingLogic {
    
    /// <#Description#>
    func closeModule()
}

/// Объект содержаний логику переходов от модуля `MovieDetails` в другие модули
final class MovieDetailsRouter: MovieDetailsRoutingLogic {
    
    private unowned let transitionController: TransitionController
    
    nonisolated init(transitionController: TransitionController) {
        self.transitionController = transitionController
    }
    
    func closeModule() {
        transitionController.dismiss()
    }
}
