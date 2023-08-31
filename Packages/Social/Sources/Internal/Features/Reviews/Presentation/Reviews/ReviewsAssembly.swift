//  
//  ReviewsAssembly.swift
//  TMDB

import CArch
import CArchSwinject

/// Пространство имен модуля Reviews
public struct ReviewsModule {

    /// Объект содержащий логику создания модуля `Reviews`
    /// с чистой иерархии (просто ViewController)
    public final class Builder: ClearHierarchyModuleBuilder {
        
        public typealias InitialStateType = ReviewsModuleState.InitialStateType

        private let factory: LayoutAssemblyFactory
        
        init(_ factory: LayoutAssemblyFactory, _ services: PreviewsServices = .init()) {
            self.factory = factory
            self.factory.record(services)
        }

        public func build(with initialState: InitialStateType) -> CArchModule {
            let module = build()
            module.initializer?.set(initialState: initialState)
            return module
        }
        
        public func build() -> CArchModule {
            factory
                .assembly(ReviewsAssembly.self)
                .unravel(ReviewsViewController.self)
        }
    }
}

/// Объект содержащий логику внедрения зависимости компонентов модула `Reviews`
final class ReviewsAssembly: LayoutModuleAssembly {
    
    required init() {
        print("ReviewsModuleAssembly is beginning assembling")
    }
    
    func registerView(in container: DIContainer) {
        container.record(ReviewsViewController.self) { resolver in
            let controller = ReviewsViewController()
            guard
                let presenter = resolver.unravel(ReviewsPresentationLogic.self,
                                                 arguments: controller as ReviewsRenderingLogic,
                                                 controller as ReviewsModuleStateRepresentable)
            else { preconditionFailure("Could not to build Reviews module, module Presenter is nil") }
            controller.renderer = resolver.unravel(ReviewsRenderer.self, argument: controller as ReviewsUserInteraction)
            controller.router = resolver.unravel(ReviewsRoutingLogic.self, argument: controller as TransitionController)
            controller.provider = resolver.unravel(ReviewsProvisionLogic.self, argument: presenter as ReviewsPresentationLogic)
            return controller
        }
    }
    
    func registerRenderers(in container: DIContainer) {
        container.record(ReviewsRenderer.self) { (_, interaction: ReviewsUserInteraction) in
            ReviewsRenderer(interactional: interaction)
        }
    }

    func registerPresenter(in container: DIContainer) {
        container.record(ReviewsPresentationLogic.self) { (resolver, view: ReviewsRenderingLogic, state: ReviewsModuleStateRepresentable) in
            ReviewsPresenter(view: view, state: state)
        }
    }

    func registerProvider(in container: DIContainer) {
        container.record(ReviewsProvisionLogic.self) { (resolver, presenter: ReviewsPresentationLogic) in
            ReviewsProvider(presenter: presenter,
                            previewsService: resolver.unravel(PreviewsService.self)!)
        }
    }
    
    func registerRouter(in container: DIContainer) {
        container.record(ReviewsRoutingLogic.self) { (resolver, transitionController: TransitionController) in
            ReviewsRouter(transitionController: transitionController)
        }
    }
}
