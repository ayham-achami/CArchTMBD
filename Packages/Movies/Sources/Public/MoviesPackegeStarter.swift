//
//  MoviesPackegeStarter.swift

import CArch
import TMDBCore
import Foundation

public final class MoviesPackegeStarter: LayoutPackegeStarter {
    
    public func movies(_ initialState: MoviesModuleState.InitialState) -> CArchModule {
        MoviesModule.TabHierarchyBuilder(factroy).build(with: initialState)
    }
    
    public func detalis(_ initialState: MovieDetailsModuleState.InitialState) -> CArchModule {
        MovieDetailsModule.Builder(factroy).build(with: initialState)
    }
}
