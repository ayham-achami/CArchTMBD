//
//  PreviewFactory.swift

#if DEBUG
import CArch
import TMDBCore
import Foundation
import CArchSwinject

private let factory: LayoutAssemblyFactory = .init()

private final class MockAuthNavigator: AuthNavigator {
    
    nonisolated init() {}
    
    func destination(for bound: AuthBounds) -> Destination {
        switch bound {
        case .login:
            return .init(LoginModule.Builder(factory).build(), .main)
        }
    }
}

private final class MockAuthNavigatorAssembly: DIAssembly {
    
    nonisolated init() {}
    
    func assemble(container: DIContainer) {
        container.record(AuthNavigator.self, inScope: .autoRelease) { _ in
            MockAuthNavigator()
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
        
        private let buidler: Builder
        
        init() {
            factory.record(MockServicesAssembly())
            buidler = .init(factory)
        }

        func build(with initialState: InitialStateType) -> CArchModule {
            let module = build()
            module.initializer?.set(initialState: initialState)
            return module
        }
        
        func build() -> CArchModule {
            buidler.build()
        }
    }
}
#endif
