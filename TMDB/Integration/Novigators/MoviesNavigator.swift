//
//  MoviesNavigator.swift
//  TMDB

import CArch
import Movies
import TMDBCore
import Foundation
import CArchSwinject

@MainActor final class MoviesNavigatorImplementation: MoviesNavigator {
    
    private let factory: LayoutAssemblyFactory
    
    nonisolated init(_ provider: FactoryProvider) {
        self.factory = provider.factory
    }
    
    func destination(for bound: MoviesBounds) -> Destination {
        fatalError()
    }
}

final class MoviesNavigatorAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.record(MoviesNavigator.self, inScope: .autoRelease) { resolver in
            MoviesNavigatorImplementation(resolver.unravel(FactoryProvider.self)!)
        }
    }
}
