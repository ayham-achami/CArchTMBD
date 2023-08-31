//  ___FILEHEADER___

import CArch
import CArchSwinject

/// Пространство имен модуля ___VARIABLE_productName___
public struct ___VARIABLE_productName___Module {

    /// Объект содержащий логику создания модуля `___VARIABLE_productName___`
    /// с чистой иерархии (просто ViewController)
    public final class Builder: ClearHierarchyModuleBuilder {
        
        public typealias InitialStateType = ___VARIABLE_productName___ModuleState.InitialStateType

        public init() {}

        public func build(with initialState: InitialStateType) -> CArchModule {
            let module = build()
            module.initializer?.set(initialState: initialState)
            return module
        }
        
        public func build() -> CArchModule {
            LayoutAssemblyFactory
                .assembly(___VARIABLE_productName___Assembly.self)
                .unravel(___VARIABLE_productName___ViewController.self)
        }
    }
}

/// Объект содержащий логику внедрения зависимости компонентов модула `___VARIABLE_productName___`
final class ___VARIABLE_productName___Assembly: LayoutModuleAssembly {
    
    required init() {
        print("___VARIABLE_productName___ModuleAssembly is beginning assembling")
    }
    
    func registerView(in container: DIContainer) {
        container.record(___VARIABLE_productName___ViewController.self) { resolver in
            let controller = ___VARIABLE_productName___ViewController()
            guard
                let presenter = resolver.unravel(___VARIABLE_productName___PresentationLogic.self,
                                                 arguments: controller as ___VARIABLE_productName___RenderingLogic,
                                                 controller as ___VARIABLE_productName___ModuleStateRepresentable)
            else { preconditionFailure("Could not to build ___VARIABLE_productName___ module, module Presenter is nil") }
            controller.renderer = resolver.unravel(___VARIABLE_productName___Renderer.self, argument: controller as ___VARIABLE_productName___UserInteraction)
            controller.router = resolver.unravel(___VARIABLE_productName___RoutingLogic.self, argument: controller as TransitionController)
            controller.provider = resolver.unravel(___VARIABLE_productName___ProvisionLogic.self, argument: presenter as ___VARIABLE_productName___PresentationLogic)
            return controller
        }
    }
    
    func registerRenderers(in container: DIContainer) {
        container.record(___VARIABLE_productName___Renderer.self) { (_, interaction: ___VARIABLE_productName___UserInteraction) in
            ___VARIABLE_productName___Renderer(interactional: interaction)
        }
    }

    func registerPresenter(in container: DIContainer) {
        container.record(___VARIABLE_productName___PresentationLogic.self) { (resolver, view: ___VARIABLE_productName___RenderingLogic, state: ___VARIABLE_productName___ModuleStateRepresentable) in
            ___VARIABLE_productName___Presenter(view: view, state: state)
        }
    }

    func registerProvider(in container: DIContainer) {
        container.record(___VARIABLE_productName___ProvisionLogic.self) { (resolver, presenter: ___VARIABLE_productName___PresentationLogic) in
            ___VARIABLE_productName___Provider(presenter: presenter)
        }
    }
    
    func registerRouter(in container: DIContainer) {
        container.record(___VARIABLE_productName___RoutingLogic.self) { (resolver, transitionController: TransitionController) in
            ___VARIABLE_productName___Router(transitionController: transitionController)
        }
    }
}
