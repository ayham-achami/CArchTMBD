//  
//  PersonPresenter.swift
//  
//
//  Created by Ayham Hylam on 12.09.2023.
//

import CArch

/// Протокол реализующий логику отображения данных
@UIContactor
@MainActor protocol PersonRenderingLogic: RootRenderingLogic {
    
    func display(_ model: PersonRenderer.ModelType)
}

/// Объект содержащий логику преобразования объектов модели `Model` в
/// объекты `UIModel` (ViewModel) модуля `Person`
final class PersonPresenter: PersonPresentationLogic {
    
    private weak var view: PersonRenderingLogic?
    private weak var state: PersonModuleStateRepresentable?
    
    init(view: PersonRenderingLogic,
         state: PersonModuleStateRepresentable) {
        self.view = view
        self.state = state
    }

    func didObtain(_ person: Person) {
        view?.nonisolatedDisplay(.init(person))
    }
    
    func encountered(_ error: Error) {
        Task {
            await view?.displayErrorAlert(with: error)
        }
    }
}

// MARK: - Private methods
private extension PersonPresenter {}

private extension PersonRenderer.ModelType {
    
    init(_ person: Person) {
        self.portraitPath = person.profilePath
    }
}
