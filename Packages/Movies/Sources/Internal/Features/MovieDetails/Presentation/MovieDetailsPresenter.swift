//  
//  MovieDetailsPresenter.swift

import CArch
import CRest
import Foundation

/// Протокол реализующий логику отображения данных
@UIContactor
@MainActor protocol MovieDetailsRenderingLogic: RootRenderingLogic {
    
    /// Показать детали фильма
    /// - Parameter details: Детали фильма
    func display(_ details: MovieDetailsRenderer.ModelType)
    
    /// Показать ошибку загрузки
    /// - Parameter errorDescription: Ошибку загрузки
    func display(errorDescription: String)
}

/// Объект содержащий логику преобразования объектов модели `Model` в
/// объекты `UIModel` (ViewModel) модуля `MovieDetails`
final class MovieDetailsPresenter: MovieDetailsPresentationLogic {
    
    private weak var view: MovieDetailsRenderingLogic?
    private weak var state: MovieDetailsModuleStateRepresentable?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()
    
    private lazy var timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        return formatter
    }()
    
    private lazy var currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        formatter.usesGroupingSeparator = true
        return formatter
    }()
    
    init(view: MovieDetailsRenderingLogic,
         state: MovieDetailsModuleStateRepresentable) {
        self.view = view
        self.state = state
    }
    
    func didObtain(_ response: (details: MovieDetails, credits: Credits, videos: Videos)) {
        view?.nonisolatedDisplay(.init(response.details, response.credits, dateFormatter, timeFormatter, currencyFormatter))
    }

    func encountered(_ error: Error) {
        if let error = error as? NetworkError {
            view?.nonisolatedDisplay(errorDescription: error.errorDescription)
        } else {
            view?.nonisolatedDisplay(errorDescription: error.localizedDescription)
        }
    }
}

// MARK: - Private methods
private extension MovieDetailsPresenter {}

// MARK: - MovieDetailsRenderer.ModelType + Init
private extension MovieDetailsRenderer.ModelType {
    
    init(_ details: MovieDetails,
         _ credits: Credits,
         _ date: DateFormatter,
         _ time: DateComponentsFormatter,
         _ currency: NumberFormatter) {
        self.id = details.id
        self.posterPath = details.posterPath
        self.title = .init(details)
        self.overview = .init(details)
        self.about = .init(details, date, time, currency)
        self.credits = credits.cast.map(CreditCell.Model.init(_:))
    }
}

// MARK: - TitleView.Model + Init
private extension TitleView.Model {
    
    init(_ details: MovieDetails) {
        self.rating = .init(details.voteAverage / 10)
        self.title = details.title
        self.tagline = details.tagline
        self.genres = details.genres.map(\.name).joined(separator: ", ")
    }
}

// MARK: - OverviewView.Model + Init
private extension OverviewView.Model {
    
    init(_ details: MovieDetails) {
        self.overview = details.overview
    }
}

// MARK: - AboutView.Model + Init
private extension AboutView.Model {
    
    init(_ details: MovieDetails,
         _ date: DateFormatter,
         _ time: DateComponentsFormatter,
         _ currency: NumberFormatter) {
        self.date = date.string(from: details.releaseDate)
        self.status = details.status
        self.runtime = time.string(from: .init(minute: details.runtime)) ?? ""
        self.budget = currency.string(from: .init(value: details.budget)) ?? ""
        self.revenue = currency.string(from: .init(value: details.revenue)) ?? ""
        self.language = Locale.current.localizedString(forIdentifier: Locale(identifier: details.originalLanguage).identifier) ?? ""
        self.countries = Set(details.productionCompanies.map(\.originCountry)).joined(separator: ", ")
    }
}

// MARK: - CreditCell.Model + Init
private extension CreditCell.Model {
    
    init(_ cast: Cast) {
        self.id = cast.id
        self.name = cast.name
        self.character = cast.character
        self.posterPath = cast.profilePath ?? ""
    }
}
