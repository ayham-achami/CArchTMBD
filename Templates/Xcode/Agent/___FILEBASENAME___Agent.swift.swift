//
//  ___VARIABLE_productName___Agent.swift
//

import CArch
import Foundation

// MARK: - DI
final class ___VARIABLE_productName___AgentAssembly: DIAssembly { // swiftlint:disable:this type_name
    
    func assemble(container: DIContainer) {
        container.recordAgent(___VARIABLE_productName___Agent.self) { _ in
            ___VARIABLE_productName___Agent()
        }
    }
}

// MARK: - Agent
actor ___VARIABLE_productName___Agent: BusinessLogicAgent { // swiftlint:disable:this type_name
    
    init() {}
}
