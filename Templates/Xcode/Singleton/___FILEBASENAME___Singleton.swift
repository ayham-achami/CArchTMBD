//
//  ___VARIABLE_productName___Singleton.swift
//

import CArch
import Foundation

// MARK: - Contract
@Contract protocol ___VARIABLE_productName___Singleton: BusinessLogicSingleton, AutoResolve {}

// MARK: - Implementation
private actor ___VARIABLE_productName___SingletonImplementation: ___VARIABLE_productName___Singleton {
    
    init() {}
    
    init(_ resolver: DIResolver) {}
}
