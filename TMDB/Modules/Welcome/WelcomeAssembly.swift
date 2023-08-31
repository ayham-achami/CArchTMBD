//  
//  WelcomeAssembly.swift
//  TMDB

import UIKit
import CArch
import TMDBCore
import CArchSwinject

/// Пространство имен модуля Welcome
public struct WelcomeModule {

    /// Объект содержащий логику создания модуля `Welcome`
    /// с чистой иерархии (просто ViewController)
    public final class Builder: ClearHierarchyModuleBuilder {
        
        public typealias InitialStateType = WelcomeModuleState.InitialStateType

        private let factory: LayoutAssemblyFactory
        
        public init(_ factory: LayoutAssemblyFactory) {
            self.factory = factory
        }

        public func build(with initialState: InitialStateType) -> CArchModule {
            let module = build()
            module.initializer?.set(initialState: initialState)
            return module
        }
        
        public func build() -> CArchModule {
            factory
                .assembly(WelcomeAssembly.self)
                .unravel(WelcomeViewController.self)
        }
    }
    
    /// Объект содержащий логику создания модуля `Movies` c `UINavigationBuilder`
    public final class NavigationBuilder: NavigationHierarchyModuleBuilder {

        public typealias InitialStateType = WelcomeModuleState.InitialStateType

        private let factory: LayoutAssemblyFactory
        
        public init(_ factory: LayoutAssemblyFactory) {
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
            navigationController.navigationBar.prefersLargeTitles = true
            return navigationController
        }
    }
}

/// Объект содержащий логику внедрения зависимости компонентов модула `Welcome`
final class WelcomeAssembly: LayoutModuleAssembly {
    
    required init() {
        print("WelcomeModuleAssembly is beginning assembling")
    }
    
    func registerView(in container: DIContainer) {
        container.record(WelcomeViewController.self) { resolver in
            let controller = WelcomeViewController()
            guard
                let presenter = resolver.unravel(WelcomePresentationLogic.self,
                                                 arguments: controller as WelcomeRenderingLogic,
                                                 controller as WelcomeModuleStateRepresentable)
            else { preconditionFailure("Could not to build Welcome module, module Presenter is nil") }
            controller.renderer = resolver.unravel(WelcomeRenderer.self, argument: controller as WelcomeUserInteraction)
            controller.backgroundRenderer = resolver.unravel(WelcomeBackgroundRenderer.self, argument: controller as WelcomeUserInteraction)
            controller.router = resolver.unravel(WelcomeRoutingLogic.self, argument: controller as TransitionController)
            controller.provider = resolver.unravel(WelcomeProvisionLogic.self, argument: presenter as WelcomePresentationLogic)
            return controller
        }
    }
    
    func registerRenderers(in container: DIContainer) {
        container.record(WelcomeRenderer.self) { (_, interaction: WelcomeUserInteraction) in
            WelcomeRenderer(interactional: interaction)
        }
        container.record(WelcomeBackgroundRenderer.self) { (_, interaction: WelcomeUserInteraction) in
            WelcomeBackgroundRenderer(interactional: interaction)
        }
    }

    func registerPresenter(in container: DIContainer) {
        container.record(WelcomePresentationLogic.self) { (resolver, view: WelcomeRenderingLogic, state: WelcomeModuleStateRepresentable) in
            WelcomePresenter(view: view, state: state)
        }
    }

    func registerProvider(in container: DIContainer) {
        container.record(WelcomeProvisionLogic.self) { (resolver, presenter: WelcomePresentationLogic) in
            WelcomeProvider(presenter: presenter)
        }
    }
    
    func registerRouter(in container: DIContainer) {
        container.record(WelcomeRoutingLogic.self) { (resolver, transitionController: TransitionController) in
            WelcomeRouter(transitionController: transitionController,
                          factoryProvider: resolver.unravel(FactoryProvider.self)!)
        }
    }
}
