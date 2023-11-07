//
//  MovieDetailsState.swift
//

import CArch

/// Протокол передающий доступ к некоторым свойствам состояние модуля `MovieDetails` как только для чтения
protocol MovieDetailsModuleReadOnlyState: AnyReadOnlyState {}

/// Протокол передающий доступ к состоянию модуля как только для чтения
protocol MovieDetailsModuleStateRepresentable: AnyModuleStateRepresentable {
    
    var readOnly: MovieDetailsModuleReadOnlyState { get }
}

/// Состояние модуля `MovieDetails`
public struct MovieDetailsModuleState: ModuleState {
    
    public typealias InitialStateType = InitialState
    public typealias FinalStateType = FinalState
    
    public struct InitialState: ModuleInitialState {

        public let id: Int
        
        public init(id: Int) {
            self.id = id
        }
    }
    
    public struct FinalState: ModuleFinalState {

        public init() {}
    }
    
    public var initialState: MovieDetailsModuleState.InitialStateType?
    public var finalState: MovieDetailsModuleState.FinalStateType?

    public init() {}
}

// MARK: - MovieDetailsModuleState +  ReadOnly
extension MovieDetailsModuleState: MovieDetailsModuleReadOnlyState {}
