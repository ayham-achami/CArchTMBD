//
//  MoviesModuleState.swift
//

import CArch
import UIKit

/// Протокол передающий доступ к некоторым свойствам состояние модуля `Movies` как только для чтения
protocol MoviesModuleReadOnlyState: AnyReadOnlyState {}

/// Протокол передающий доступ к состоянию модуля как только для чтения
protocol MoviesModuleStateRepresentable: AnyModuleStateRepresentable {

    var readOnly: MoviesModuleReadOnlyState { get }
}

/// Состояние модуля `Movies`
public struct MoviesModuleState: ModuleState {

    public typealias InitialStateType = InitialState
    public typealias FinalStateType = FinalState
    
    public enum MoviesType {
        
        case popular
        case upcoming
        case topRated
        case nowPlaying
    }
    
    public struct InitialState: ModuleInitialState {
        
        let title: String
        let icon: UIImage
        let type: MoviesType
        
        public init(title: String, icon: UIImage, type: MoviesType) {
            self.title = title
            self.icon = icon
            self.type = type
        }
    }

    public struct FinalState: ModuleFinalState {}

    public var initialState: MoviesModuleState.InitialStateType?
    public var finalState: MoviesModuleState.FinalStateType?
    
    var page: Int = 1
    
    public init() {}
}

// MARK: - MoviesModuleState + ReadOnly
extension MoviesModuleState: MoviesModuleReadOnlyState {
    
    var type: MoviesModuleState.MoviesType {
        initial.type
    }
}
