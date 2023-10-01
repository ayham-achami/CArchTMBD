//  
//  PersonState.swift

import CArch

/// Протокол передающий доступ к некоторым свойствам состояние модуля `Person` как только для чтения
protocol PersonModuleReadOnlyState: AnyReadOnlyState {}

/// Протокол передающий доступ к состоянию модуля как только для чтения
protocol PersonModuleStateRepresentable: AnyModuleStateRepresentable {
    
    var readOnly: PersonModuleReadOnlyState { get }
}

/// Состояние модуля `Person`
public struct PersonModuleState: ModuleState {    
    
    public struct InitialState: ModuleInitialState {
        
        public let id: Int
        
        public init(id: Int) {
            self.id = id
        }
    }
    
    public struct FinalState: ModuleFinalState {
        
        public init() {}
    }
    
    public typealias InitialStateType = InitialState
    public typealias FinalStateType = FinalState
    
    public var initialState: PersonModuleState.InitialStateType?
    public var finalState: PersonModuleState.FinalStateType?

    public init() {}
}

// MARK: - PersonModuleState +  ReadOnly
extension PersonModuleState: PersonModuleReadOnlyState {}
