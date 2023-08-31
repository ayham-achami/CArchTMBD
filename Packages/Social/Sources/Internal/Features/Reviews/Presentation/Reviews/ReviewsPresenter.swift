//  
//  ReviewsPresenter.swift
//  TMDB

import CArch

/// Протокол реализующий логику отображения данных
@UIContactor
@MainActor protocol ReviewsRenderingLogic: RootRenderingLogic {
    
    func display(_ reviews: ReviewsRenderer.ModelType)
}

/// Объект содержащий логику преобразования объектов модели `Model` в
/// объекты `UIModel` (ViewModel) модуля `Reviews`
final class ReviewsPresenter: ReviewsPresentationLogic {
    
    private weak var view: ReviewsRenderingLogic?
    private weak var state: ReviewsModuleStateRepresentable?
    
    init(view: ReviewsRenderingLogic,
         state: ReviewsModuleStateRepresentable) {
        self.view = view
        self.state = state
    }
    
    func didObtain(_ reviews: [Review]) {
        view?.nonisolatedDisplay(reviews.map(ReviewNode.Model.init(_:)))
    }

    func encountered(_ error: Error) {
        Task {
            await view?.displayErrorAlert(with: error)
        }
    }
}

// MARK: - Private methods
private extension ReviewsPresenter {}

private extension ReviewNode.Model {
    
    init(_ review: Review) {
        self.id = review.id
        self.author = review.author
        self.content = review.content
        self.updatedAt = review.updatedAt
        self.createdAt = review.createdAt
    }
}
