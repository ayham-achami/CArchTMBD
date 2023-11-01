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
        container.recordComponent(LoginViewController.self) { resolver in
            let controller = LoginViewController()
            let presenter = resolver.unravelComponent(LoginPresenter.self,
                                                      argument1: controller as LoginRenderingLogic,
                                                      argument2: controller as LoginModuleStateRepresentable)
            controller.renderer = resolver.unravelComponent(LoginRenderer.self,
                                                            argument: controller as LoginUserInteraction)
            controller.router = resolver.unravelComponent(LoginRouter.self,
                                                          argument: controller as TransitionController)
            controller.provider = resolver.unravelComponent(LoginProvider.self,
                                                            argument: presenter as LoginPresentationLogic)
            return controller
        }
    }
    
    func registerRenderers(in container: DIContainer) {
        container.recordComponent(LoginRenderer.self) { (_, interaction: LoginUserInteraction) in
            LoginRenderer(interactional: interaction)
        }
    }

    func registerPresenter(in container: DIContainer) {
        container.recordComponent(LoginPresenter.self) { (resolver, view: LoginRenderingLogic, state: LoginModuleStateRepresentable) in
            LoginPresenter(view: view, state: state)
        }
    }

    func registerProvider(in container: DIContainer) {
        container.recordComponent(LoginProvider.self) { (resolver, presenter: LoginPresentationLogic) in
            LoginProvider(presenter: presenter)
        }
    }
    
    func registerRouter(in container: DIContainer) {
        container.recordComponent(LoginRouter.self) { (resolver, transitionController: TransitionController) in
            LoginRouter(transitionController: transitionController,
                        appRouter: resolver.unravel(some: ApplicationRouter.self),
                        authNavigator: resolver.unravel(some: AuthNavigator.self))
        }
    }
}
