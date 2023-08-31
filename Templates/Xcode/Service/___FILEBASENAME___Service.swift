//  ___FILEHEADER___

import CArch
import Foundation

// MAR: - DI
final class ___VARIABLE_productName___ServiceAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.record(___VARIABLE_productName___Service.self, inScope: .autoRelease) { _ in
            ___VARIABLE_productName___ServiceImplementation()
        }
    }
}

// MARK: - Public
@MaintenanceActor public protocol ___VARIABLE_productName___Service: BusinessLogicService {
}

// MARK: - Private
private final class ___VARIABLE_productName___ServiceImplementation: ___VARIABLE_productName___Service {
    
    nonisolated init() {
    }
}