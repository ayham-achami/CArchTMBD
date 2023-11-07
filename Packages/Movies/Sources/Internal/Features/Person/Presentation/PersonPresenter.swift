//
//  PersonPresenter.swift
//

import CArch
import CRest
import Foundation

/// Протокол реализующий логику отображения данных
@UIContactor
@MainActor protocol PersonRenderingLogic: RootRenderingLogic {
    
    /// Показать информации о актере
    /// - Parameter model: `PersonRenderer.ModelType`
    func display(_ model: PersonRenderer.ModelType)
    
    /// Показать ошибку загрузки
    /// - Parameter errorDescription: Ошибку загрузки
    func display(errorDescription: String)
}

/// Объект содержащий логику преобразования объектов модели `Model` в
/// объекты `UIModel` (ViewModel) модуля `Person`
final class PersonPresenter: PersonPresentationLogic {
    
    private weak var view: PersonRenderingLogic?
    private weak var state: PersonModuleStateRepresentable?
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    init(view: PersonRenderingLogic,
         state: PersonModuleStateRepresentable) {
        self.view = view
        self.state = state
    }

    func didObtain(_ person: PersonData) {
        view?.nonisolatedDisplay(.init(person.data, person.images, dateFormatter))
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
private extension PersonPresenter {}

// MARK: - PersonRenderer.ModelType + Init
private extension PersonRenderer.ModelType {
    
    init(_ person: Person, _ images: ProfileImages, _ date: DateFormatter) {
        self.portraits = images.profiles.map { .init(path: $0.filePath) }
        self.biography = .init(person)
        self.personality = .init(person)
        self.personalInfo = .init(person, date)
    }
}

// MARK: - PersonalityView.Model + Init
private extension PersonalityView.Model {
    
    init(_ person: Person) {
        self.name = person.name
        self.rating = .init(person.popularity / 100.0)
    }
}

// MARK: - PersonRenderer.Model + Init
private extension PersonalInfoView.Model {
    
    init(_ person: Person, _ date: DateFormatter) {
        self.knownFor = person.knownForDepartment
        self.gender = person.gender.description
        if let birthday = person.birthday {
            self.birthday = date.string(from: birthday)
        } else {
            self.birthday = "Unknown"
        }
        self.placeOfBirth = person.placeOfBirth ?? "Unknown"
    }
}

// MARK: - BiographyView.Model + Init
private extension BiographyView.Model {
    
    init(_ person: Person) {
        if !person.biography.isEmpty {
            self.biography = person.biography
        } else {
            self.biography = "We don't have a biography for \(person.name)."
        }
        if !person.alsoKnownAs.isEmpty {
            self.knownAs = person.alsoKnownAs.joined(separator: "\n")
        } else {
            self.knownAs = "doesn't exist"
        }
    }
}

// MARK: - Person.Gender + CustomStringConvertible
extension Person.Gender: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .none:
            return "None"
        case .female:
            return "Female"
        case .male:
            return "Male"
        case .nonBinary:
            return "Non binary"
        }
    }
}
