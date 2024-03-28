//
//  PreviewFactory.swift
//

#if DEBUG
import CArch
import CArchSwinject
import Foundation
import TMDBCore

private final class MockAuthNavigatorAssembly: DIAssembly {
    
    nonisolated init() {}
    
    func assemble(container: DIContainer) {
        container.record(some: AuthNavigator.self) { _ in
            MockAuthNavigator()
        }
    }
}

private final class MockAuthNavigator: AuthNavigator {
    
    nonisolated init() {}
    
    func destination(for bound: AuthBounds) -> Destination {
        switch bound {
        case .login:
            return .init(LoginModule.Builder(.init()).build(), .main)
        }
    }
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

private struct MockServicesAssembly: DIAssemblyCollection {
    
    var services: [DIAssembly] {
        [MockJWTControllerAssembly(),
         MockAuthNavigatorAssembly(),
         MockApplicationRouterAssembly()]
    }
}

extension LoginModule {
    
    /// Объект содержащий логику создания модуля `Login`
    /// с чистой иерархии (просто ViewController)
    final class PreviewBuilder: ClearHierarchyModuleBuilder {
        
        typealias InitialStateType = LoginModuleState.InitialStateType
        
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
            builder.build()
        }
    }
}
#endif
