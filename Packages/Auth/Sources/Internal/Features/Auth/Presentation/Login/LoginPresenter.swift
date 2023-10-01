//
//  LoginPresenter.swift

import CArch

/// Протокол реализующий логику отображения данных
@UIContactor
@MainActor protocol LoginRenderingLogic: RootRenderingLogic {}

/// Объект содержащий логику преобразования объектов модели `Model` в
/// объекты `UIModel` (ViewModel) модуля `Login`
final class LoginPresenter: LoginPresentationLogic {
    
    private weak var view: LoginRenderingLogic?
    private weak var state: LoginModuleStateRepresentable?
    
    init(view: LoginRenderingLogic,
         state: LoginModuleStateRepresentable) {
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
private extension LoginPresenter {}
