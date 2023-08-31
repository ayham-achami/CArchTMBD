//
//  MoviesRouter.swift

import UIKit
import CArch
import TMDBCore

/// Протокол организующий логику переходов от модуля `Movies` в другие модули
protocol MoviesRoutingLogic: RootRoutingLogic {
    
    /// <#Description#>
    /// - Parameter initialState: <#initialState description#>
    func showMovieDetails(_ initialState: MovieDetailsModuleState.InitialState)
}

/// Объект содержаний логику переходов от модуля `Movies` в другие модули
final class MoviesRouter: MoviesRoutingLogic {

    private let factoryProvider: FactoryProvider
    private unowned let transitionController: TransitionController

    nonisolated init(transitionController: TransitionController, factoryProvider: FactoryProvider) {
        self.factoryProvider = factoryProvider
        self.transitionController = transitionController
    }
    
    func showMovieDetails(_ initialState: MovieDetailsModuleState.InitialState) {
        TransitionBuilder
            .with(transitionController)
            .with(state: initialState)
            .with(hierarchy: .clear)
            .with(transition: .present)
            .with(builder: MovieDetailsModule.Builder(factoryProvider.factroy))
            .commit()
        
    }
}
