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
            navigationController.navigationBar.tintColor = Colors.invertBack.color
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
        container.recordComponent(PersonViewController.self) { resolver in
            let controller = PersonViewController()
            let presenter = resolver.unravelComponent(PersonPresenter.self,
                                                      argument1: controller as PersonRenderingLogic,
                                                      argument2: controller as PersonModuleStateRepresentable)
            controller.renderer = resolver.unravelComponent(PersonRenderer.self, argument: controller as PersonUserInteraction)
            controller.stateRenderer = resolver.unravelComponent(StateRenderer.self, argument: controller as PersonUserInteraction)
            controller.router = resolver.unravelComponent(PersonRouter.self, argument: controller as TransitionController)
            controller.provider = resolver.unravelComponent(PersonProvider.self, argument: presenter as PersonPresentationLogic)
            return controller
        }
    }
    
    func registerRenderers(in container: DIContainer) {
        container.recordComponent(PersonRenderer.self) { (_, interaction: PersonUserInteraction) in
            PersonRenderer(interactional: interaction)
        }
        container.recordComponent(StateRenderer.self) { (_, interaction: PersonUserInteraction) in
            StateRenderer(interactional: interaction)
        }
    }

    func registerPresenter(in container: DIContainer) {
        container.recordComponent(PersonPresenter.self) { (resolver, view: PersonRenderingLogic, state: PersonModuleStateRepresentable) in
            PersonPresenter(view: view, state: state)
        }
    }

    func registerProvider(in container: DIContainer) {
        container.recordComponent(PersonProvider.self) { (resolver, presenter: PersonPresentationLogic) in
            PersonProvider(presenter: presenter,
                           personService: resolver.unravelService(PersonService.self))
        }
    }
    
    func registerRouter(in container: DIContainer) {
        container.recordComponent(PersonRouter.self) { (resolver, transitionController: TransitionController) in
            PersonRouter(transitionController: transitionController)
        }
    }
}
