//
//  ReviewsRouter.swift
//

import CArch

/// Протокол организующий логику переходов от модуля `Reviews` в другие модули
protocol ReviewsRoutingLogic: RootRoutingLogic {}

/// Объект содержаний логику переходов от модуля `Reviews` в другие модули
final class ReviewsRouter {
    
    private unowned let transitionController: TransitionController
    
    init(transitionController: TransitionController) {
        self.transitionController = transitionController
    }
}

// MARK: - ReviewsRouter + ReviewsRoutingLogic
extension ReviewsRouter: ReviewsRoutingLogic {}
