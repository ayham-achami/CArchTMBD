//  
//  ReviewsState.swift
//  TMDB

import CArch

/// Протокол передающий доступ к некоторым свойствам состояние модуля `Reviews` как только для чтения
protocol ReviewsModuleReadOnlyState: AnyReadOnlyState {}

/// Протокол передающий доступ к состоянию модуля как только для чтения
protocol ReviewsModuleStateRepresentable: AnyModuleStateRepresentable {
    
    var readOnly: ReviewsModuleReadOnlyState { get }
}

/// Состояние модуля `Reviews`
public struct ReviewsModuleState: ModuleState {    
    
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
    
    public var initialState: ReviewsModuleState.InitialStateType?
    public var finalState: ReviewsModuleState.FinalStateType?

    public init() {}
}

// MARK: - ReviewsModuleState +  ReadOnly
extension ReviewsModuleState: ReviewsModuleReadOnlyState {}
