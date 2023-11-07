//
//  PreviewFactory.swift
//

#if DEBUG
import CArch
import CArchSwinject
import Foundation
import TMDBCore
import UIKit

private final class MockSocialNavigatorAssembly: DIAssembly { // swiftlint:disable:this file_types_order
    
    nonisolated init() {}
    
    func assemble(container: DIContainer) {
        container.record(SocialNavigator.self, inScope: .autoRelease, configuration: nil) { _ in
            MockSocialNavigator()
        }
    }
}

private final class MockSocialNavigator: SocialNavigator {
    
    nonisolated init() {}
    
    func destination(for bound: SocialBounds) -> Destination {}
}

private final class MockApplicationRouterAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.record(ApplicationRouter.self, inScope: .autoRelease, configuration: nil) { _ in
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
        container.record(JWTController.self, inScope: .autoRelease, configuration: nil) { _ in
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

private final class MockFactoryProviderAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.record(FactoryProvider.self, inScope: .autoRelease, configuration: nil) { _ in
            MockFactoryProvider()
        }
    }
}

private struct MockServicesAssembly: DIAssemblyCollection {
    
    var services: [DIAssembly] {
        [MockJWTControllerAssembly(),
         MockSocialNavigatorAssembly(),
         MockApplicationRouterAssembly()]
    }
}

private final class MockFactoryProvider: FactoryProvider {
    
    var factory: LayoutAssemblyFactory {
        .init()
    }
}

extension ReviewsModule {
    
    /// Объект содержащий логику создания модуля `Reviews`
    /// с чистой иерархии (просто ViewController)
    final class PreviewBuilder: ClearHierarchyModuleBuilder {
        
        typealias InitialStateType = ReviewsModuleState.InitialStateType
        
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
            builder.build(with: .init(id: 872585))
        }
    }
}
#endif
