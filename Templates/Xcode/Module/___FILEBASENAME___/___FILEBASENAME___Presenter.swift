//
//  ___VARIABLE_productName___Presenter.swift
//

import CArch

/// Протокол реализующий логику отображения данных
@UIContactor
@MainActor protocol ___VARIABLE_productName___RenderingLogic: RootRenderingLogic {}

/// Объект содержащий логику преобразования объектов модели `Model` в
/// объекты `UIModel` (ViewModel) модуля `___VARIABLE_productName___`
final class ___VARIABLE_productName___Presenter: ___VARIABLE_productName___PresentationLogic {
    
    private weak var view: ___VARIABLE_productName___RenderingLogic?
    private weak var state: ___VARIABLE_productName___ModuleStateRepresentable?
    
    init(view: ___VARIABLE_productName___RenderingLogic,
         state: ___VARIABLE_productName___ModuleStateRepresentable) {
        self.view = view
        self.state = state
    }

    func encountered(_ error: Error) {
        view?.nonisolatedDisplayErrorAlert(with: error)
    }
}

// MARK: - Private methods
private extension ___VARIABLE_productName___Presenter {}
