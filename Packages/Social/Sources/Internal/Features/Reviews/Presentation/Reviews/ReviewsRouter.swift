//  
//  ReviewsRouter.swift
//  TMDB

import CArch

/// Протокол организующий логику переходов от модуля `Reviews` в другие модули
protocol ReviewsRoutingLogic: RootRoutingLogic {}

/// Объект содержаний логику переходов от модуля `Reviews` в другие модули
final class ReviewsRouter: ReviewsRoutingLogic {
    
    private unowned let transitionController: TransitionController
    
    nonisolated init(transitionController: TransitionController) {
        self.transitionController = transitionController
    }
}
