//
//  WelcomeState.swift
//

import CArch

/// Протокол передающий доступ к некоторым свойствам состояние модуля `Welcome` как только для чтения
protocol WelcomeModuleReadOnlyState: AnyReadOnlyState {}

/// Протокол передающий доступ к состоянию модуля как только для чтения
protocol WelcomeModuleStateRepresentable: AnyModuleStateRepresentable {
    
    var readOnly: WelcomeModuleReadOnlyState { get }
}

/// Состояние модуля `Welcome`
public struct WelcomeModuleState: ModuleState {
    
    public typealias InitialStateType = InitialState
    public typealias FinalStateType = FinalState
    
    public struct InitialState: ModuleInitialState {}
    
    public struct FinalState: ModuleFinalState {}
    
    public var initialState: WelcomeModuleState.InitialStateType?
    public var finalState: WelcomeModuleState.FinalStateType?

    public init() {}
}

// MARK: - WelcomeModuleState +  ReadOnly
extension WelcomeModuleState: WelcomeModuleReadOnlyState {}
