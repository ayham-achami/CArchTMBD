//  
//  PersonAssembly.swift
//  

import UIKit
import CArch
import TMDBUIKit
import CArchSwinject

/// Пространство имен модуля Person
public struct PersonModule {

    /// Объект содержащий логику создания модуля `Person`
    /// с чистой иерархии (просто ViewController)
    public final class Builder: ClearHierarchyModuleBuilder {
        
        public typealias InitialStateType = PersonModuleState.InitialStateType

        private let factory: LayoutAssemblyFactory
        
        init(_ factory: LayoutAssemblyFactory, _ services: PersonServices = .init()) {
            self.factory = factory
            self.factory.record(services)
        }

        public func build(with initialState: InitialStateType) -> CArchModule {
            let module = build()
            module.initializer?.set(initialState: initialState)
            return module
        }
        
        public func build() -> CArchModule {
            factory.assembly(PersonAssembly.self).unravel(PersonViewController.self)
        }
    }
    
    /// Объект содержащий логику создания модуля `Person` c `UINavigationBuilder`
    public final class NavigationBuilder: NavigationHierarchyModuleBuilder {

        public typealias InitialStateType = PersonModuleState.InitialStateType

        private let factory: LayoutAssemblyFactory
        
        init(_ factory: LayoutAssemblyFactory) {
            self.factory = factory
        }
        
        public func build(with initialState: InitialStateType) -> CArchModule {
            embedIntoNavigationController(Builder(factory).build(with: initialState))
        }

        public func build() -> CArchModule {
            embedIntoNavigationController(Builder(factory).build())
        }
        
        public func embedIntoNavigationController(_ module: CArchModule) -> CArchModule {
            let navigationController = UINavigationController(rootViewController: module.node)
            navigationController.navigationBar.tintColor = .white
            navigationController.navigationBar.shadowImage = .init()
            navigationController.navigationBar.backgroundColor = .clear
            navigationController.navigationBar.prefersLargeTitles = false
            navigationController.navigationBar.setBackgroundImage(.init(), for: .default)
            return navigationController
        }
    }
}

/// Объект содержащий логику внедрения зависимости компонентов модула `Person`
final class PersonAssembly: LayoutModuleAssembly {
    
    required init() {
        print("PersonModuleAssembly is beginning assembling")
    }
    
    func registerView(in container: DIContainer) {
        container.record(PersonViewController.self) { resolver in
            let controller = PersonViewController()
            guard
                let presenter = resolver.unravel(PersonPresentationLogic.self,
                                                 arguments: controller as PersonRenderingLogic,
                                                 controller as PersonModuleStateRepresentable)
            else { preconditionFailure("Could not to build Person module, module Presenter is nil") }
            controller.renderer = resolver.unravel(PersonRenderer.self, argument: controller as PersonUserInteraction)
            controller.stateRenderer = resolver.unravel(StateRenderer.self, argument: controller as PersonUserInteraction)
            controller.router = resolver.unravel(PersonRoutingLogic.self, argument: controller as TransitionController)
            controller.provider = resolver.unravel(PersonProvisionLogic.self, argument: presenter as PersonPresentationLogic)
            return controller
        }
    }
    
    func registerRenderers(in container: DIContainer) {
        container.record(PersonRenderer.self) { (_, interaction: PersonUserInteraction) in
            PersonRenderer(interactional: interaction)
        }
        container.record(StateRenderer.self) { (_, interaction: PersonUserInteraction) in
            StateRenderer(interactional: interaction)
        }
    }

    func registerPresenter(in container: DIContainer) {
        container.record(PersonPresentationLogic.self) { (resolver, view: PersonRenderingLogic, state: PersonModuleStateRepresentable) in
            PersonPresenter(view: view, state: state)
        }
    }

    func registerProvider(in container: DIContainer) {
        container.record(PersonProvisionLogic.self) { (resolver, presenter: PersonPresentationLogic) in
            PersonProvider(presenter: presenter,
                           personService: resolver.unravel(PersonService.self)!)
        }
    }
    
    func registerRouter(in container: DIContainer) {
        container.record(PersonRoutingLogic.self) { (resolver, transitionController: TransitionController) in
            PersonRouter(transitionController: transitionController)
        }
    }
}
