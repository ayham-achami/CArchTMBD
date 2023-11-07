//
//  LoginState.swift
//

import CArch

/// Протокол передающий доступ к некоторым свойствам состояние модуля `Login` как только для чтения
protocol LoginModuleReadOnlyState: AnyReadOnlyState {}

/// Протокол передающий доступ к состоянию модуля как только для чтения
protocol LoginModuleStateRepresentable: AnyModuleStateRepresentable {
    
    var readOnly: LoginModuleReadOnlyState { get }
}

/// Состояние модуля `Login`
public struct LoginModuleState: ModuleState {
    
    public typealias InitialStateType = InitialState
    public typealias FinalStateType = FinalState
    
    public struct InitialState: ModuleInitialState {
        
        enum ModuleStartType: String {
            
            case firstType
        }
        
        public init() {}
    }
    
    public struct FinalState: ModuleFinalState {
        
        public init() {}
    }
    
    public var initialState: LoginModuleState.InitialStateType?
    public var finalState: LoginModuleState.FinalStateType?

    var userName: String?
    
    public init() {}
}

// MARK: - LoginModuleState +  ReadOnly
extension LoginModuleState: LoginModuleReadOnlyState {}
