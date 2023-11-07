//
//  WelcomePresenter.swift
//

import CArch

/// Протокол реализующий логику отображения данных
@UIContactor
@MainActor protocol WelcomeRenderingLogic: RootRenderingLogic {
    
    func display(_ posters: [String])
}

/// Объект содержащий логику преобразования объектов модели `Model` в
/// объекты `UIModel` (ViewModel) модуля `Welcome`
final class WelcomePresenter: WelcomePresentationLogic {
    
    private weak var view: WelcomeRenderingLogic?
    private weak var state: WelcomeModuleStateRepresentable?
    
    init(view: WelcomeRenderingLogic,
         state: WelcomeModuleStateRepresentable) {
        self.view = view
        self.state = state
    }
    
    func didObtain(_ posters: [String]) {
        view?.nonisolatedDisplay(posters)
    }

    func encountered(_ error: Error) {
        Task {
            await view?.displayErrorAlert(with: error)
        }
    }
}

// MARK: - Private methods
private extension WelcomePresenter {}
