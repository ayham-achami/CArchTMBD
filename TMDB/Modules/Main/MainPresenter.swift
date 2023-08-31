//
//  MainPresenter.swift
//  TMDB

import CArch

/// Протокол реализующий логику отображения данных
protocol MainRenderingLogic: RootRenderingLogic {}

/// Объект содержащий логику преобразования объектов модели `Model` в
/// объекты `UIModel` (ViewModel) модуля `Main`
final class MainPresenter: MainPresentationLogic {
    
    private weak var view: MainRenderingLogic?
    private weak var state: MainModuleStateRepresentable?
    
    init(view: MainRenderingLogic,
         state: MainModuleStateRepresentable) {
        self.view = view
        self.state = state
    }

    func encountered(_ error: Error) {
        Task {
            await view?.displayErrorAlert(with: error)
        }
    }
}

// MARK: - Private methods
private extension MainPresenter {}
