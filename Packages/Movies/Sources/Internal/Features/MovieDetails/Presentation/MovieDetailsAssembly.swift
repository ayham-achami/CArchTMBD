//
//  MovieDetailsAssembly.swift

import UIKit
import CArch
import TMDBCore
import TMDBUIKit
import CArchSwinject

/// Пространство имен модуля MovieDetails
public struct MovieDetailsModule {
    
    /// Объект содержащий логику создания модуля `MovieDetails`
    /// с чистой иерархии (просто ViewController)
    public final class Builder: ClearHierarchyModuleBuilder {
        
        public typealias InitialStateType = MovieDetailsModuleState.InitialStateType
        
        private let factory: LayoutAssemblyFactory
        
        init(_ factory: LayoutAssemblyFactory, services: MovieDetailsServices = .init()) {
            self.factory = factory
            self.factory.record(services)
        }
        
        public func build(with initialState: InitialStateType) -> CArchModule {
            let module = build()
            module.initializer?.set(initialState: initialState)
            return module
        }
        
        public func build() -> CArchModule {
            factory.assembly(MovieDetailsAssembly.self).unravel(MovieDetailsViewController.self)
        }
    }
    
    /// Объект содержащий логику создания модуля `MovieDetails` c `UINavigationBuilder`
    public final class NavigationBuilder: NavigationHierarchyModuleBuilder {

        public typealias InitialStateType = MovieDetailsModuleState.InitialStateType

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

/// Объект содержащий логику внедрения зависимости компонентов модула `MovieDetails`
final class MovieDetailsAssembly: LayoutModuleAssembly {
    
    required init() {
        print("MovieDetailsModuleAssembly is beginning assembling")
    }
    
    func registerView(in container: DIContainer) {
        container.recordComponent(MovieDetailsViewController.self) { resolver in
            let controller = MovieDetailsViewController()
            let presenter = resolver.unravelComponent(MovieDetailsPresenter.self,
                                                      argument1: controller as MovieDetailsRenderingLogic,
                                                      argument2: controller as MovieDetailsModuleStateRepresentable)
            controller.detailsRenderer = resolver.unravelComponent(MovieDetailsRenderer.self, argument: controller as MovieDetailsUserInteraction)
            controller.stateRenderer = resolver.unravelComponent(StateRenderer.self, argument: controller as MovieDetailsUserInteraction)
            controller.router = resolver.unravelComponent(MovieDetailsRouter.self, argument: controller as TransitionController)
            controller.provider = resolver.unravelComponent(MovieDetailsProvider.self, argument: presenter as MovieDetailsPresentationLogic)
            return controller
        }
    }
    
    func registerRenderers(in container: DIContainer) {
        container.recordComponent(MovieDetailsRenderer.self) { (_, interaction: MovieDetailsUserInteraction) in
            MovieDetailsRenderer(interactional: interaction)
        }
        container.recordComponent(StateRenderer.self) { (_, interaction: MovieDetailsUserInteraction) in
            StateRenderer(interactional: interaction)
        }
    }
    
    func registerPresenter(in container: DIContainer) {
        container.recordComponent(MovieDetailsPresenter.self) { (resolver, view: MovieDetailsRenderingLogic, state: MovieDetailsModuleStateRepresentable) in
            MovieDetailsPresenter(view: view, state: state)
        }
    }
    
    func registerProvider(in container: DIContainer) {
        container.recordComponent(MovieDetailsProvider.self) { (resolver, presenter: MovieDetailsPresentationLogic) in
            MovieDetailsProvider(presenter: presenter,
                                 movieDetailsService: resolver.unravelService(MovieDetailsService.self))
        }
    }
    
    func registerRouter(in container: DIContainer) {
        container.recordComponent(MovieDetailsRouter.self) { (resolver, transitionController: TransitionController) in
            MovieDetailsRouter(transitionController: transitionController,
                               factoryProvider: resolver.unravel(some: FactoryProvider.self))
        }
    }
}
