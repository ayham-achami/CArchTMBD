//
//  MoviesPresenter.swift

import CArch
import Foundation

/// Протокол реализующий логику отображения данных
@MainActor protocol MoviesRenderingLogic: RootRenderingLogic {
    
    /// Показать загруженные фильмы
    /// - Parameter movies: Загруженные фильмы
     func display(_ movies: [MovieCell.Model])
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
        Task {
            await view?.display(movies.map { .init($0, formatter) })
        }
    }
    
    func encountered(_ error: Error) {
        Task {
            await view?.displayErrorAlert(with: error)
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

