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
        container.recordComponent(___VARIABLE_productName___ViewController.self) { resolver in
            let controller = ___VARIABLE_productName___ViewController()
            let presenter = resolver.unravelComponent(___VARIABLE_productName___Presenter.self,
                                                      argument1: controller as ___VARIABLE_productName___RenderingLogic,
                                                      argument2: controller as ___VARIABLE_productName___ModuleStateRepresentable)
            controller.renderer = resolver.unravelComponent(___VARIABLE_productName___Renderer.self,
                                                            argument: controller as ___VARIABLE_productName___UserInteraction)
            controller.router = resolver.unravelComponent(___VARIABLE_productName___Router.self,
                                                          argument: controller as TransitionController)
            controller.provider = resolver.unravelComponent(___VARIABLE_productName___Provider.self,
                                                            argument: presenter as ___VARIABLE_productName___PresentationLogic)
            return controller
        }
    }
    
    func registerRenderers(in container: DIContainer) {
        container.recordComponent(___VARIABLE_productName___Renderer.self) { (_, interaction: ___VARIABLE_productName___UserInteraction) in
            ___VARIABLE_productName___Renderer(interactional: interaction)
        }
    }
    
    func registerPresenter(in container: DIContainer) {
        container.recordComponent(___VARIABLE_productName___Presenter.self) { (resolver, view: ___VARIABLE_productName___RenderingLogic, state: ___VARIABLE_productName___ModuleStateRepresentable) in
            ___VARIABLE_productName___Presenter(view: view, state: state)
        }
    }
    
    func registerProvider(in container: DIContainer) {
        container.recordComponent(___VARIABLE_productName___Provider.self) { (resolver, presenter: ___VARIABLE_productName___PresentationLogic) in
            ___VARIABLE_productName___Provider(presenter: presenter)
        }
    }
    
    func registerRouter(in container: DIContainer) {
        container.recordComponent(___VARIABLE_productName___Router.self) { (resolver, transitionController: TransitionController) in
            ___VARIABLE_productName___Router(transitionController: transitionController)
        }
    }
}
