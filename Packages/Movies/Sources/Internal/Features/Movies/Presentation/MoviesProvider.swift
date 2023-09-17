//
//  MoviesProvider.swift

import CArch
import Foundation

/// Протокол взаимодействия с `MoviesPresenter`
protocol MoviesPresentationLogic: RootPresentationLogic {
    
    /// Вызывается при получении фильмов
    /// - Parameter movies: Загруженные фильмы
    func didObtain(_ movies: [Movie])
}

/// Объект содержаний логику получения данных из слоя бизнес логики
/// все типы данных передаются `MoviesPresenter` как `UIModel`
final class MoviesProvider: MoviesProvisionLogic {

    private let presenter: MoviesPresentationLogic
    private let moviesService: MoviesService

    /// Инициализация провайдера модуля `Movies`
    /// - Parameter presenter: `MoviesPresenter`
    /// - Parameter moviesService: `MoviesService`
    nonisolated init(presenter: MoviesPresentationLogic,
                     moviesService: MoviesService) {
        self.presenter = presenter
        self.moviesService = moviesService
    }
    
    func obtainMovies(of type: MoviesModuleState.MoviesType, at page: Int) async throws {
        let movies: MoviesList
        switch type {
        case .popular:
            movies = try await moviesService.fetchPopular(page)
        case .upcoming:
            movies = try await moviesService.fetchUpcoming(page)
        case .topRated:
            movies = try await moviesService.fetchTopRated(page)
        case .nowPlaying:
            movies = try await moviesService.fetchNowPlaying(page)
        }
        presenter.didObtain(movies.results)
    }
    
    func encountered(_ error: Error) {
        presenter.encountered(error)
    }
}
