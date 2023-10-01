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
            navigationController.navigationBar.tintColor = .white
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
        container.record(MovieDetailsViewController.self) { resolver in
            let controller = MovieDetailsViewController()
            guard
                let presenter = resolver.unravel(MovieDetailsPresentationLogic.self,
                                                 arguments: controller as MovieDetailsRenderingLogic,
                                                 controller as MovieDetailsModuleStateRepresentable)
            else { preconditionFailure("Could not to build MovieDetails module, module Presenter is nil") }
            controller.detailsRenderer = resolver.unravel(MovieDetailsRenderer.self, argument: controller as MovieDetailsUserInteraction)
            controller.stateRenderer = resolver.unravel(StateRenderer.self, argument: controller as MovieDetailsUserInteraction)
            controller.router = resolver.unravel(MovieDetailsRoutingLogic.self, argument: controller as TransitionController)
            controller.provider = resolver.unravel(MovieDetailsProvisionLogic.self, argument: presenter as MovieDetailsPresentationLogic)
            return controller
        }
    }
    
    func registerRenderers(in container: DIContainer) {
        container.record(MovieDetailsRenderer.self) { (_, interaction: MovieDetailsUserInteraction) in
            MovieDetailsRenderer(interactional: interaction)
        }
        container.record(StateRenderer.self) { (_, interaction: MovieDetailsUserInteraction) in
            StateRenderer(interactional: interaction)
        }
    }
    
    func registerPresenter(in container: DIContainer) {
        container.record(MovieDetailsPresentationLogic.self) { (resolver, view: MovieDetailsRenderingLogic, state: MovieDetailsModuleStateRepresentable) in
            MovieDetailsPresenter(view: view, state: state)
        }
    }
    
    func registerProvider(in container: DIContainer) {
        container.record(MovieDetailsProvisionLogic.self) { (resolver, presenter: MovieDetailsPresentationLogic) in
            MovieDetailsProvider(presenter: presenter,
                                 movieDetailsService: resolver.unravel(MovieDetailsService.self)!)
        }
    }
    
    func registerRouter(in container: DIContainer) {
        container.record(MovieDetailsRoutingLogic.self) { (resolver, transitionController: TransitionController) in
            MovieDetailsRouter(transitionController: transitionController,
                               factoryProvider: resolver.unravel(FactoryProvider.self)!)
        }
    }
}
