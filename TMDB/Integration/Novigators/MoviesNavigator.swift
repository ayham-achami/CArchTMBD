//
//  MoviesNavigator.swift
//

import CArch
import CArchSwinject
import Foundation
import Movies
import TMDBCore

@MainActor final class MoviesNavigatorImplementation: MoviesNavigator {
    
    private let factory: LayoutAssemblyFactory
    
    nonisolated init(_ provider: FactoryProvider) {
        self.factory = provider.factory
    }
    
    func destination(for bound: MoviesBounds) -> Destination {}
}

final class MoviesNavigatorAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.record(MoviesNavigator.self, inScope: .autoRelease, configuration: nil) { resolver in
            MoviesNavigatorImplementation(resolver.unravel(some: FactoryProvider.self))
        }
    }
}
