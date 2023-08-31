//
//  MainAssembly.swift
//  TMDB

import CArch
import CArchSwinject

/// Пространство имен модуля Main
struct MainModule {

    /// Объект содержащий логику создания модуля `Main` 
    /// с чистой иерархии (просто ViewController) 
    final class Builder: ClearHierarchyModuleBuilder {
        
        typealias InitialStateType = MainModuleState.InitialStateType
        
        private let factory: LayoutAssemblyFactory
        
        public init(_ factory: LayoutAssemblyFactory) {
            self.factory = factory
        }
        
        func build(with initialState: InitialStateType) -> CArchModule {
            let module = build()
            module.initializer?.set(initialState: initialState)
            return module

        }
        
        func build() -> CArchModule {
            factory
                .assembly(MainAssembly.self)
                .unravel(MainViewController.self)
        }
    }
}

/// Объект содержащий логику внедрения зависимости компонентов модула `Main`
final class MainAssembly: LayoutModuleAssembly {
    
    required init() {
        print("MainModuleAssembly is beginning assembling")
    }
    
    func registerView(in container: DIContainer) {
        container.record(MainViewController.self) { resolver in
            let controller = MainViewController()
            guard
                let presenter = resolver.unravel(MainPresentationLogic.self,
                                                 arguments: controller as MainRenderingLogic,
                                                 controller as MainModuleStateRepresentable)
            else { preconditionFailure("Could not to build Main module, module Presenter is nil") }
            controller.renderer = resolver.unravel(MainRenderer.self, argument: controller as MainUserInteraction)
            controller.router = resolver.unravel(MainRoutingLogic.self, argument: controller as TransitionController)
            controller.provider = resolver.unravel(MainProvisionLogic.self, argument: presenter as MainPresentationLogic)
            return controller
        }
    }
    
    func registerRenderers(in container: DIContainer) {
        container.record(MainRenderer.self) { (_, interaction: MainUserInteraction) in
            MainRenderer(interactional: interaction)
        }
    }

    func registerPresenter(in container: DIContainer) {
        container.record(MainPresentationLogic.self) { (resolver, view: MainRenderingLogic, state: MainModuleStateRepresentable) in
            MainPresenter(view: view, state: state)
        }
    }

    func registerProvider(in container: DIContainer) {
        container.record(MainProvisionLogic.self) { (resolver, presenter: MainPresentationLogic) in
            MainProvider(presenter: presenter)
        }
    }
    
    func registerRouter(in container: DIContainer) {
        container.record(MainRoutingLogic.self) { (resolver, transitionController: TransitionController) in
            MainRouter(transitionController: transitionController)
        }
    }
}
