//  
//  MovieDetailsPresenter.swift

import CArch
import Foundation

/// Протокол реализующий логику отображения данных
@UIContactor
@MainActor protocol MovieDetailsRenderingLogic: RootRenderingLogic {
    
    /// <#Description#>
    /// - Parameter details: <#details description#>
    func display(_ details: MovieDetailsRenderer.ModelType)
}

/// Объект содержащий логику преобразования объектов модели `Model` в
/// объекты `UIModel` (ViewModel) модуля `MovieDetails`
final class MovieDetailsPresenter: MovieDetailsPresentationLogic {
    
    private weak var view: MovieDetailsRenderingLogic?
    private weak var state: MovieDetailsModuleStateRepresentable?
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()
    
    private let timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        return formatter
    }()
    
    private let currencyFormatter: NumberFormatter = {
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
    
    func didObtain(_ response: (details: MovieDetails, credits: Credits)) {
        view?.nonisolatedDisplay(.init(response.details, response.credits, dateFormatter, timeFormatter, currencyFormatter))
    }

    func encountered(_ error: Error) {
        Task {
            await view?.displayErrorAlert(with: error)
        }
    }
}

// MARK: - Private methods
private extension MovieDetailsPresenter {}

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

private extension TitleView.Model {
    
    init(_ details: MovieDetails) {
        self.rating = .init(details.voteAverage / 10)
        self.title = details.title
        self.tagline = details.tagline
        self.genres = details.genres.map(\.name).joined(separator: ", ")
    }
}

private extension OverviewView.Model {
    
    init(_ details: MovieDetails) {
        self.overview = details.overview
    }
}

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

private extension CreditCell.Model {
    
    init(_ cast: Cast) {
        self.id = cast.id
        self.name = cast.name
        self.character = cast.character
        self.posterPath = cast.profilePath ?? ""
    }
}
