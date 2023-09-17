//
//  MoviesPackageStarter.swift

import CArch
import TMDBCore
import Foundation

public final class MoviesPackageStarter: LayoutPackageStarter {
    
    public func clearMovies(_ initialState: MoviesModuleState.InitialState) -> CArchModule {
        MoviesModule.Builder(factory).build(with: initialState)
    }
    
    public func movies(_ initialState: MoviesModuleState.InitialState) -> CArchModule {
        MoviesModule.TabHierarchyBuilder(factory).build(with: initialState)
    }
    
    public func details(_ initialState: MovieDetailsModuleState.InitialState) -> CArchModule {
        MovieDetailsModule.Builder(factory).build(with: initialState)
    }
}
