//  
//  MovieDetailsRouter.swift

import CArch
import TMDBCore

/// Протокол организующий логику переходов от модуля `MovieDetails` в другие модули
protocol MovieDetailsRoutingLogic: RootRoutingLogic {
    
    func showPersoneDetailes(_ initialState: PersonModuleState.InitialState)
    
    /// <#Description#>
    func closeModule()
}

/// Объект содержаний логику переходов от модуля `MovieDetails` в другие модули
final class MovieDetailsRouter: MovieDetailsRoutingLogic {
    
    private let factoryProvider: FactoryProvider
    private unowned let transitionController: TransitionController
    
    nonisolated init(transitionController: TransitionController,
                     factoryProvider: FactoryProvider) {
        self.transitionController = transitionController
        self.factoryProvider = factoryProvider
    }
    
    func showPersoneDetailes(_ initialState: PersonModuleState.InitialState) {
        TransitionBuilder
            .with(transitionController)
            .with(state: initialState)
            .with(hierarchy: .clear)
            .with(transition: .present)
            .with(builder: PersonModule.Builder(factoryProvider.factory))
            .commit()
    }
    
    func closeModule() {
        transitionController.dismiss()
    }
}
