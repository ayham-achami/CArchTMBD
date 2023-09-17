//  
//  MovieDetailsProvider.swift

import CArch

/// Протокол взаимодействия с MovieDetailsPresenter
protocol MovieDetailsPresentationLogic: RootPresentationLogic {
    
    /// <#Description#>
    /// - Parameter details: <#details description#>
    func didObtain(_ response: (details: MovieDetails, credits: Credits))
}

/// Объект содержаний логику получения данных из слоя бизнес логики 
/// все типы данных передаются MovieDetailsPresenter как `UIModel`
final class MovieDetailsProvider: MovieDetailsProvisionLogic {
    
    private let presenter: MovieDetailsPresentationLogic
    private let movieDetailsService: MovieDetailsService
    
    /// Инициализация провайдера модуля `MovieDetails`
    /// - Parameter presenter: `MovieDetailsPresenter`
    /// - Parameter movieDetailsService: `MovieDetailsService`
    nonisolated init(presenter: MovieDetailsPresentationLogic,
                     movieDetailsService: MovieDetailsService) {
        self.presenter = presenter
        self.movieDetailsService = movieDetailsService
    }
    
    func obtainMovieDetails(with id: Int) async throws {
        let response = try await (details: movieDetailsService.fetchDetails(with: id),
                                  credits: movieDetailsService.fetchCast(with: id))
        presenter.didObtain(response)
    }
    
    func encountered(_ error: Error) {
        presenter.encountered(error)
    }
}
