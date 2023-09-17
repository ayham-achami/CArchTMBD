//  
//  PersonProvider.swift
//  
//
//  Created by Ayham Hylam on 12.09.2023.
//

import CArch

/// Протокол взаимодействия с PersonPresenter
protocol PersonPresentationLogic: RootPresentationLogic {
    
    func didObtain(_ person: Person)
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
        let person = try await personService.fetchPerson(with: id)
        presenter.didObtain(person)
    }
    
    func encountered(_ error: Error) {
        presenter.encountered(error)
    }
}
