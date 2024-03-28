//
//  ReviewsProvider.swift
//

import CArch

/// Протокол взаимодействия с ReviewsPresenter
protocol ReviewsPresentationLogic: RootPresentationLogic {
    
    func didObtain(_ reviews: [Review])
}

/// Объект содержаний логику получения данных из слоя бизнес логики
/// все типы данных передаются ReviewsPresenter как `UIModel`
final class ReviewsProvider {
    
    private let previewsService: PreviewsService
    private let presenter: ReviewsPresentationLogic
    
    /// Инициализация провайдера модуля `Reviews`
    /// - Parameter presenter: `ReviewsPresenter`
    /// - Parameter socialService: `SocialService`
    init(presenter: ReviewsPresentationLogic,
         previewsService: PreviewsService) {
        self.presenter = presenter
        self.previewsService = previewsService
    }
}

// MARK: - ReviewsProvider + ReviewsProvisionLogic
extension ReviewsProvider: ReviewsProvisionLogic {
    
    func obtainReviews(for id: Int) async throws {
        let response = try await previewsService.fetchReviews(for: id)
        presenter.didObtain(response.results)
    }
    
    func encountered(_ error: Error) {
        presenter.encountered(error)
    }
}
