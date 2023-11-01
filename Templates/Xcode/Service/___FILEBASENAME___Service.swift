//  ___FILEHEADER___

import CArch
import Foundation

// MARK: - DI
final class ___VARIABLE_productName___ServiceAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.recordService(___VARIABLE_productName___Service.self) { _ in
            ___VARIABLE_productName___Service()
        }
    }
}

// MARK: - Service
actor ___VARIABLE_productName___Service: BusinessLogicService {
    
    init() {}
}
