//
//  LoginProvider.swift
//

import CArch

/// Протокол взаимодействия с LoginPresenter
protocol LoginPresentationLogic: RootPresentationLogic {}

/// Объект содержаний логику получения данных из слоя бизнес логики
/// все типы данных передаются LoginPresenter как `UIModel`
final class LoginProvider {
    
    private let presenter: LoginPresentationLogic
    
    /// Инициализация провайдера модуля `Login`
    /// - Parameter presenter: `LoginPresenter`
    init(presenter: LoginPresentationLogic) {
        self.presenter = presenter
    }
}

// MARK: - LoginProvider + LoginProvisionLogic
extension LoginProvider: LoginProvisionLogic {
    
    func encountered(_ error: Error) {
        presenter.encountered(error)
    }
}
