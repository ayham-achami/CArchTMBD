//
//  MainState.swift
//

import CArch

/// Протокол передающий доступ к некоторым свойствам состояние модуля `Main` как только для чтения
protocol MainModuleReadOnlyState: AnyReadOnlyState {}

/// Протокол передающий доступ к состоянию модуля как только для чтения
protocol MainModuleStateRepresentable: AnyModuleStateRepresentable {
    
    var readOnly: MainModuleReadOnlyState { get }
}

/// Состояние модуля `Main`
struct MainModuleState: ModuleState {
    
    typealias InitialStateType = InitialState
    typealias FinalStateType = FinalState
    
    struct InitialState: ModuleInitialState {}
    
    struct FinalState: ModuleFinalState {}
    
    var initialState: MainModuleState.InitialStateType?
    var finalState: MainModuleState.FinalStateType?
}

// MARK: - MainModuleState +  ReadOnly
extension MainModuleState: MainModuleReadOnlyState {}
