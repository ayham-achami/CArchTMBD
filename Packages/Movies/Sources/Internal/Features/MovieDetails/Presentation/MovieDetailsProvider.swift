//
//  MovieDetailsProvider.swift
//

import CArch

/// Протокол взаимодействия с MovieDetailsPresenter
protocol MovieDetailsPresentationLogic: RootPresentationLogic {
    
    /// Вызывается при получении данных о фильме
    /// - Parameter details: `MovieDetails` + `Credits`
    func didObtain(_ response: (details: MovieDetails, credits: Credits, videos: Videos))
}

/// Объект содержаний логику получения данных из слоя бизнес логики
/// все типы данных передаются MovieDetailsPresenter как `UIModel`
final class MovieDetailsProvider {
    
    private let presenter: MovieDetailsPresentationLogic
    private let movieDetailsService: MovieDetailsService
    
    /// Инициализация провайдера модуля `MovieDetails`
    /// - Parameter presenter: `MovieDetailsPresenter`
    /// - Parameter movieDetailsService: `MovieDetailsService`
    init(presenter: MovieDetailsPresentationLogic,
         movieDetailsService: MovieDetailsService) {
        self.presenter = presenter
        self.movieDetailsService = movieDetailsService
    }
}

// MARK: - MovieDetailsProvider + MovieDetailsProvisionLogic
extension MovieDetailsProvider: MovieDetailsProvisionLogic {
    
    func obtainMovieDetails(with id: Int) async throws {
        let response = try await (details: movieDetailsService.fetchDetails(with: id),
                                  credits: movieDetailsService.fetchCast(with: id),
                                  videos: movieDetailsService.fetchVideos(with: id))
        presenter.didObtain(response)
    }
    
    func encountered(_ error: Error) {
        presenter.encountered(error)
    }
}
