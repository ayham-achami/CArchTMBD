//
//  MoviesRouter.swift
//

import CArch
import TMDBCore
import UIKit

/// Протокол организующий логику переходов от модуля `Movies` в другие модули
protocol MoviesRoutingLogic: RootRoutingLogic {
    
    /// Показать модуль детали фильма
    /// - Parameter initialState: `MovieDetailsModuleState.InitialState`
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
            .with(hierarchy: .navigation)
            .with(transition: .customPresent(.formSheet, .coverVertical))
            .with(builder: MovieDetailsModule.NavigationBuilder(factoryProvider.factory))
            .commit()
    }
}
