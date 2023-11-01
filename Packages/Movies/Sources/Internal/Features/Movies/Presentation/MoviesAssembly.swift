//
//  MoviesAssembly.swift

import UIKit
import CArch
import TMDBCore
import TMDBUIKit
import CArchSwinject

/// Пространство имен модуля Movies
public struct MoviesModule {

    /// Объект содержащий логику создания модуля `Movies`
    /// с чистой иерархии (просто ViewController)
    public final class Builder: ClearHierarchyModuleBuilder {
        
        public typealias InitialStateType = MoviesModuleState.InitialStateType
        
        private let factory: LayoutAssemblyFactory
        
        init(_ factory: LayoutAssemblyFactory, _ services: MoviesServices = .init()) {
            self.factory = factory
            self.factory.record(services)
        }
        
        public func build(with initialState: InitialStateType) -> CArchModule {
            let module = build()
            module.initializer?.set(initialState: initialState)
            return module
        }
        
        public func build() -> CArchModule {
            factory.assembly(MoviesAssembly.self).unravel(MoviesViewController.self)
        }
    }
    
    /// Объект содержащий логику создания модуля `Movies` c `UINavigationBuilder`
    public final class NavigationBuilder: NavigationHierarchyModuleBuilder {

        public typealias InitialStateType = MoviesModuleState.InitialStateType

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
            navigationController.navigationBar.prefersLargeTitles = true
            return navigationController
        }
    }
    
    /// Объект содержащий логику создания модуля `Movies` c `UITabBarItem`
    public final class TabHierarchyBuilder: TabHierarchyModuleBuilder {
        
        public typealias InitialStateType = MoviesModuleState.InitialState
        
        private let factory: LayoutAssemblyFactory
        
        init(_ factory: LayoutAssemblyFactory) {
            self.factory = factory
        }
        
        public func build(with initialState: MoviesModuleState.InitialState) -> CArchModule {
            let module = NavigationBuilder(factory).build(with: initialState)
            module.node.tabBarItem.image = initialState.icon
            module.node.tabBarItem.title = initialState.title
            return module
        }
        
        public func build() -> CArchModule {
            NavigationBuilder(factory).build()
        }
    }
}

/// Объект содержащий логику внедрения зависимости компонентов модула `Movies`
final class MoviesAssembly: LayoutModuleAssembly {
    
    required init() {
        print("MoviesModuleAssembly is beginning assembling")
    }
    
    func registerView(in container: CArch.DIContainer) {
        container.recordComponent(MoviesViewController.self) { resolver in
            let controller = MoviesViewController()
            let presenter = resolver.unravelComponent(MoviesPresenter.self,
                                                      argument1: controller as MoviesRenderingLogic,
                                                      argument2: controller as MoviesModuleStateRepresentable)
            controller.provider = resolver.unravelComponent(MoviesProvider.self,
                                                            argument: presenter as MoviesPresentationLogic)
            controller.router = resolver.unravelComponent(MoviesRouter.self,
                                                          argument: controller as TransitionController)
            controller.stateRenderer = resolver.unravelComponent(StateRenderer.self, 
                                                                 argument: controller as MoviesUserInteraction)
            controller.moviesRenderer = resolver.unravelComponent(MoviesRenderer.self,
                                                                  argument: controller as MoviesUserInteraction)
            return controller
        }
    }
    
    func registerRenderers(in container: CArch.DIContainer) {
        container.recordComponent(MoviesRenderer.self) { (_, interaction: MoviesUserInteraction) in
            MoviesRenderer(interactional: interaction)
        }
        container.recordComponent(StateRenderer.self) { (_, interaction: MoviesUserInteraction) in
            StateRenderer(interactional: interaction)
        }
    }
    
    func registerPresenter(in container: CArch.DIContainer) {
        container.recordComponent(MoviesPresenter.self) { (_, view: MoviesRenderingLogic, state: MoviesModuleStateRepresentable) in
            MoviesPresenter(view: view, state: state)
        }
    }
    
    func registerProvider(in container: CArch.DIContainer) {
        container.recordComponent(MoviesProvider.self) { (resolver, presenter: MoviesPresentationLogic) in
            MoviesProvider(presenter: presenter,
                           moviesService: resolver.unravel(some: MoviesService.self))
        }
    }
    
    func registerRouter(in container: CArch.DIContainer) {
        container.recordComponent(MoviesRouter.self) { (resolver, transitionController: TransitionController) in
            MoviesRouter(transitionController: transitionController,
                         factoryProvider: resolver.unravel(some: FactoryProvider.self))
        }
    }
}
