//
//  MoviesPresenter.swift
//

import CArch
import CRest
import Foundation

/// Протокол реализующий логику отображения данных
@UIContactor
@MainActor protocol MoviesRenderingLogic: RootRenderingLogic {
    
    /// Показать загруженные фильмы
    /// - Parameter movies: Загруженные фильмы
     func display(_ movies: [MovieCell.Model])
    
    /// Показать ошибку загрузки
    /// - Parameter errorDescription: Ошибку загрузки
    func display(errorDescription: String)
}

/// Объект содержащий логику преобразования объектов модели `Model` в
/// объекты `UIModel` (ViewModel) модуля `Movies`
final class MoviesPresenter: MoviesPresentationLogic {

    private weak var view: MoviesRenderingLogic?
    private weak var state: MoviesModuleStateRepresentable?

    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()
    
    init(view: MoviesRenderingLogic,
         state: MoviesModuleStateRepresentable) {
        self.view = view
        self.state = state
    }

    func didObtain(_ movies: [Movie]) {
        view?.nonisolatedDisplay(movies.map { .init($0, formatter) })
    }
    
    func encountered(_ error: Error) {
        if let error = error as? NetworkError {
            view?.nonisolatedDisplay(errorDescription: error.errorDescription)
        } else {
            view?.nonisolatedDisplay(errorDescription: error.localizedDescription)
        }
    }
}

private extension MovieCell.Model {
    
    init(_ movie: Movie, _ formatter: DateFormatter) {
        self.id = movie.id
        self.name = movie.title
        self.rating = .init(movie.voteAverage / 10)
        self.posterPath = movie.posterPath ?? ""
        self.releaseDate = formatter.string(from: movie.releaseDate)
    }
}
