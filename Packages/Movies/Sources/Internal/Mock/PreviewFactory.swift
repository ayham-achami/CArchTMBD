//
//  PreviewFactory.swift
//  

#if DEBUG
import UIKit
import CArch
import TMDBCore
import Foundation
import CArchSwinject

private let layoutAssemblyFactory: LayoutAssemblyFactory = .init()

private final class MockMoviesNavigator: MoviesNavigator {
    
    nonisolated init() {}
    
    func destination(for bound: MoviesBounds) -> Destination {
        fatalError()
    }
}

private final class MockMoviesNavigatorAssembly: DIAssembly {
    
    nonisolated init() {}
    
    func assemble(container: DIContainer) {
        container.record(MoviesNavigator.self, inScope: .autoRelease) { _ in
            MockMoviesNavigator()
        }
    }
}

private final class MockApplicationRouter: ApplicationRouter {
    
    nonisolated init() {}
    
    func show(_ destination: TMDBCore.Destination) {
        print("Won to show \(destination)")
    }
}

private final class MockApplicationRouterAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.record(ApplicationRouter.self, inScope: .autoRelease) { _ in
            MockApplicationRouter()
        }
    }
}

private final class MockJWTController: JWTController {
        
    let token: JWT = ("", "")
    let state: TMDBCore.AuthState = .unauthorized
    
    func rest() {
        print("Has reset JWT")
    }
    
    func set(_ token: JWT) throws {
        print("Has set JWT")
    }
}

private final class MockJWTControllerAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.record(JWTController.self, inScope: .autoRelease) { _ in
            MockJWTController()
        }
    }
}

private final class MockFactoryProvider: FactoryProvider {
    
    var factroy: LayoutAssemblyFactory {
        layoutAssemblyFactory
    }
}

private final class MockFactoryProviderAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.record(FactoryProvider.self, inScope: .autoRelease) { _ in
            MockFactoryProvider()
        }
    }
}

private struct MockServicesAssembly: DIAssemblyCollection {
    
    var services: [DIAssembly] {
        [MockJWTControllerAssembly(),
         MockMoviesNavigatorAssembly(),
         MockApplicationRouterAssembly()]
    }
}

extension MoviesModule {
    
    /// Объект содержащий логику создания модуля `Movies`
    /// с чистой иерархии (просто ViewController)
    final class PreviewBuilder: ClearHierarchyModuleBuilder {
        
        typealias InitialStateType = MoviesModuleState.InitialStateType
        
        private let builder: Builder
        
        init() {
            layoutAssemblyFactory.record(MockServicesAssembly())
            builder = .init(layoutAssemblyFactory)
        }

        func build(with initialState: InitialStateType) -> CArchModule {
            let module = build()
            module.initializer?.set(initialState: initialState)
            return module
        }
        
        func build() -> CArchModule {
            builder.build(with: .init(title: "Movies", icon: UIImage(systemName: "star.square.fill")!, type: .popular))
        }
    }
}

extension MovieDetailsModule {
 
    /// Объект содержащий логику создания модуля `MovieDetails`
    /// с чистой иерархии (просто ViewController)
    final class PreviewBuilder: ClearHierarchyModuleBuilder {
        
        typealias InitialStateType = MovieDetailsModuleState.InitialStateType
        
        private let builder: Builder
        
        init() {
            layoutAssemblyFactory.record(MockServicesAssembly())
            builder = .init(layoutAssemblyFactory)
        }

        func build(with initialState: InitialStateType) -> CArchModule {
            let module = build()
            module.initializer?.set(initialState: initialState)
            return module
        }
        
        func build() -> CArchModule {
            builder.build(with: .init(id: 298618))
        }
    }
}
#endif
