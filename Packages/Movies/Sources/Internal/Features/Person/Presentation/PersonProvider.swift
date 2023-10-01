//  
//  PersonProvider.swift

import CArch

/// Протокол взаимодействия с PersonPresenter
protocol PersonPresentationLogic: RootPresentationLogic {
    
    typealias PersonData = (data: Person, images: ProfileImages, movies: ProfileMovies)
    
    /// Вызывается при получении данных о актере
    /// - Parameter person: `PersonData`
    func didObtain(_ person: PersonData)
}

/// Объект содержаний логику получения данных из слоя бизнес логики 
/// все типы данных передаются PersonPresenter как `UIModel`
final class PersonProvider: PersonProvisionLogic {
    
    private let personService: PersonService
    private let presenter: PersonPresentationLogic
    
    /// Инициализация провайдера модуля `Person`
    /// - Parameter presenter: `PersonPresenter`
    /// - Parameter personService: `PersonService`
    nonisolated init(presenter: PersonPresentationLogic, personService: PersonService) {
        self.presenter = presenter
        self.personService = personService
    }
    
    func obtainPerson(with id: Int) async throws {
        let person = try await (personService.fetchPerson(with: id),
                                personService.fetchImages(with: id),
                                personService.fetchMovies(with: id))
        presenter.didObtain(person)
    }
    
    func encountered(_ error: Error) {
        presenter.encountered(error)
    }
}
