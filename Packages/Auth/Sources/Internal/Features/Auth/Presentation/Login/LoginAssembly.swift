//
//  LoginAssembly.swift

import CArch
import TMDBCore
import CArchSwinject

/// Пространство имен модуля Login
public struct LoginModule {

    /// Объект содержащий логику создания модуля `Login` 
    /// с чистой иерархии (просто ViewController) 
    public final class Builder: ClearHierarchyModuleBuilder {
        
        public typealias InitialStateType = LoginModuleState.InitialStateType

        private let factory: LayoutAssemblyFactory
        
        init(_ factory: LayoutAssemblyFactory, loginServices: LoginServices = .init()) {
            self.factory = factory
            self.factory.record(loginServices)
        }

        public func build(with initialState: InitialStateType) -> CArchModule {
            let module = build()
            module.initializer?.set(initialState: initialState)
            return module
        }
        
        public func build() -> CArchModule {
            factory.assembly(LoginAssembly.self).unravel(LoginViewController.self)
        }
    }
}

/// Объект содержащий логику внедрения зависимости компонентов модула `Login`
final class LoginAssembly: LayoutModuleAssembly {
    
    required init() {
        print("LoginModuleAssembly is beginning assembling")
    }
    
    func registerView(in container: DIContainer) {
        container.record(LoginViewController.self) { resolver in
            let controller = LoginViewController()
            guard
                let presenter = resolver.unravel(LoginPresentationLogic.self,
                                                 arguments: controller as LoginRenderingLogic,
                                                 controller as LoginModuleStateRepresentable)
            else { preconditionFailure("Could not to build Login module, module Presenter is nil") }
            controller.renderer = resolver.unravel(LoginRenderer.self, argument: controller as LoginUserInteraction)
            controller.router = resolver.unravel(LoginRoutingLogic.self, argument: controller as TransitionController)
            controller.provider = resolver.unravel(LoginProvisionLogic.self, argument: presenter as LoginPresentationLogic)
            return controller
        }
    }
    
    func registerRenderers(in container: DIContainer) {
        container.record(LoginRenderer.self) { (_, interaction: LoginUserInteraction) in
            LoginRenderer(interactional: interaction)
        }
    }

    func registerPresenter(in container: DIContainer) {
        container.record(LoginPresentationLogic.self) { (resolver, view: LoginRenderingLogic, state: LoginModuleStateRepresentable) in
            LoginPresenter(view: view, state: state)
        }
    }

    func registerProvider(in container: DIContainer) {
        container.record(LoginProvisionLogic.self) { (resolver, presenter: LoginPresentationLogic) in
            LoginProvider(presenter: presenter)
        }
    }
    
    func registerRouter(in container: DIContainer) {
        container.record(LoginRoutingLogic.self) { (resolver, transitionController: TransitionController) in
            LoginRouter(transitionController: transitionController,
                        appRouter: resolver.unravel(ApplicationRouter.self)!,
                        authNavigator: resolver.unravel(AuthNavigator.self)!)
        }
    }
}
