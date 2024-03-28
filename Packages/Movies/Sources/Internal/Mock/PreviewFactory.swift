//
//  PreviewFactory.swift
//

#if DEBUG
import CArch
import CArchSwinject
import CRest
import Foundation
import TMDBCore
import UIKit

private final class MockFactoryProviderAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.record(some: FactoryProvider.self) { _ in
            MockFactoryProvider()
        }
    }
}

private final class MockFactoryProvider: FactoryProvider {
    
    var factory: LayoutAssemblyFactory {
        .init()
    }
}

private final class MockMoviesNavigatorAssembly: DIAssembly {
    
    nonisolated init() {}
    
    func assemble(container: DIContainer) {
        container.record(some: MoviesNavigator.self) { _ in
            MockMoviesNavigator()
        }
    }
}

private final class MockMoviesNavigator: MoviesNavigator {
    
    nonisolated init() {}
    
    func destination(for bound: MoviesBounds) -> Destination {}
}

private final class MockApplicationRouterAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.record(some: ApplicationRouter.self) { _ in
            MockApplicationRouter()
        }
    }
}

private final class MockApplicationRouter: ApplicationRouter {
    
    nonisolated init() {}
    
    func show(_ destination: TMDBCore.Destination) {
        print("Won to show \(destination)")
    }
}

private final class MockJWTControllerAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.record(some: JWTController.self) { _ in
            MockJWTController()
        }
        container.record(some: JWTProvider.self) { resolver in
            resolver.unravel(some: MockJWTController.self)
        }
    }
}

private final class MockJWTController: JWTController {
        
    var token: JWT {
        // swiftlint:disable:next line_length
        ("eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3NWQ4YTY1MDVkYmU2Y2NhODc5MmEwODJlNmI2ZDU2ZSIsInN1YiI6IjVjODE0NmY3YzNhMzY4NGU4ZmQ2M2E0ZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.-1fOBevFQKbPvFdbVs4zFDwHUJknj3644PHInA1tWSw", "")
    }
    let state: TMDBCore.AuthState = .unauthorized
    
    func rest() {
        print("Has reset JWT")
    }
    
    func set(_ token: JWT) throws {
        print("Has set JWT")
    }
}

private struct MockServicesAssembly: DIAssemblyCollection {
    
    var services: [DIAssembly] {
        [MockJWTControllerAssembly(),
         MockMoviesNavigatorAssembly(),
         MockFactoryProviderAssembly(),
         MockApplicationRouterAssembly(),
         MockBearerAuthenticatorAssembly()]
    }
}

private final class MockBearerAuthenticatorAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.record(some: IOBearerAuthenticator.self) { resolver in
            MockBearerAuthenticator(provider: .init(credential: .init(access: resolver.unravel(some: JWTController.self).token.access)))
        }
    }
}

final class MockBearerAuthenticator: IOBearerAuthenticator {
    
    final class Provider: BearerCredentialProvider {
        
        final class Credential: BearerCredential {
            
            let access: String
            let isValidated: Bool = true
            
            init(access: String) {
                self.access = access
            }
        }
        
        var credential: BearerCredential
        
        func refresh() async throws -> CRest.BearerCredential {
            fatalError()
        }
        
        init(credential: Credential) {
            self.credential = credential
        }
    }
    
    let refreshStatusCodes: [Int] = [401]
    let provider: BearerCredentialProvider
    
    var refreshRequest: Request {
        fatalError()
    }
    
    init(provider: Provider) {
        self.provider = provider
    }
}

extension MoviesModule {
    
    /// Объект содержащий логику создания модуля `Movies`
    /// с чистой иерархии (просто ViewController)
    final class PreviewBuilder: ClearHierarchyModuleBuilder {
        
        typealias InitialStateType = MoviesModuleState.InitialStateType
        
        private let builder: Builder
        
        init() {
            let factory = LayoutAssemblyFactory()
            factory.record(MockServicesAssembly())
            builder = .init(factory)
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
            let factory = LayoutAssemblyFactory()
            factory.record(MockServicesAssembly())
            builder = .init(factory)
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

extension PersonModule {
    
    /// Объект содержащий логику создания модуля `MovieDetails`
    /// с чистой иерархии (просто ViewController)
    final class PreviewBuilder: ClearHierarchyModuleBuilder {
        
        typealias InitialStateType = MovieDetailsModuleState.InitialStateType
        
        private let builder: Builder
        
        init() {
            let factory = LayoutAssemblyFactory()
            factory.record(MockServicesAssembly())
            builder = .init(factory)
        }

        func build(with initialState: InitialStateType) -> CArchModule {
            let module = build()
            module.initializer?.set(initialState: initialState)
            return module
        }
        
        func build() -> CArchModule {
            builder.build(with: .init(id: 234352))
        }
    }
}
#endif
