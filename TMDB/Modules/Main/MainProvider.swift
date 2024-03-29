//
//  MainProvider.swift
//

import CArch

/// Протокол взаимодействия с MainPresenter
protocol MainPresentationLogic: RootPresentationLogic {}

/// Объект содержаний логику получения данных из слоя бизнес логики
/// все типы данных передаются MainPresenter как `UIModel`
final class MainProvider {
    
    private let presenter: MainPresentationLogic
    
    /// Инициализация провайдера модуля `Main`
    /// - Parameter presenter: `MainPresenter`
    init(presenter: MainPresentationLogic) {
        self.presenter = presenter
    }
}

// MARK: - MainProvider + MainProvisionLogic
extension MainProvider: MainProvisionLogic {
    
    func encountered(_ error: Error) {
        presenter.encountered(error)
    }
}
