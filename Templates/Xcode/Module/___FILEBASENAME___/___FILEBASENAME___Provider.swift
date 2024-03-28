//
//  ___VARIABLE_productName___Provider.swift
//

import CArch

/// Протокол взаимодействия с ___VARIABLE_productName___Presenter
protocol ___VARIABLE_productName___PresentationLogic: RootPresentationLogic {}

/// Объект содержаний логику получения данных из слоя бизнес логики 
/// все типы данных передаются ___VARIABLE_productName___Presenter как `UIModel`
final class ___VARIABLE_productName___Provider {
    
    private let presenter: ___VARIABLE_productName___PresentationLogic
    
    /// Инициализация провайдера модуля `___VARIABLE_productName___`
    /// - Parameter presenter: `___VARIABLE_productName___Presenter`
    init(presenter: ___VARIABLE_productName___PresentationLogic) {
        self.presenter = presenter
    }
}

// MARK: - ___VARIABLE_productName___Provider + ___VARIABLE_productName___ProvisionLogic
extension ___VARIABLE_productName___Provider: ___VARIABLE_productName___ProvisionLogic {
    
    func encountered(_ error: Error) {
        presenter.encountered(error)
    }
}
