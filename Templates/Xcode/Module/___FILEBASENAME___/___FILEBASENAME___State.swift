//
//  ___VARIABLE_productName___State.swift
//

import CArch

/// Протокол передающий доступ к некоторым свойствам состояние модуля `___VARIABLE_productName___` как только для чтения
protocol ___VARIABLE_productName___ModuleReadOnlyState: AnyReadOnlyState {}

/// Протокол передающий доступ к состоянию модуля как только для чтения
protocol ___VARIABLE_productName___ModuleStateRepresentable: AnyModuleStateRepresentable {
    
    var readOnly: ___VARIABLE_productName___ModuleReadOnlyState { get }
}

/// Состояние модуля `___VARIABLE_productName___`
public struct ___VARIABLE_productName___ModuleState: ModuleState {    
    
    public typealias InitialStateType = InitialState
    public typealias FinalStateType = FinalState
    
    public struct InitialState: ModuleInitialState {
        
        public init() {}
    }
    
    public struct FinalState: ModuleFinalState {
        
        public init() {}
    }
    
    public var initialState: ___VARIABLE_productName___ModuleState.InitialStateType?
    public var finalState: ___VARIABLE_productName___ModuleState.FinalStateType?

    public init() {}
}

// MARK: - ___VARIABLE_productName___ModuleState +  ReadOnly
extension ___VARIABLE_productName___ModuleState: ___VARIABLE_productName___ModuleReadOnlyState {}
