//
//  ReviewsAssembly.swift
//

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
        container.recordComponent(ReviewsViewController.self) { resolver in
            let controller = ReviewsViewController()
            let presenter = resolver.unravelComponent(ReviewsPresenter.self,
                                                      argument1: controller as ReviewsRenderingLogic,
                                                      argument2: controller as ReviewsModuleStateRepresentable)
            controller.renderer = resolver.unravelComponent(ReviewsRenderer.self,
                                                            argument: controller as ReviewsUserInteraction)
            controller.router = resolver.unravelComponent(ReviewsRouter.self,
                                                          argument: controller as TransitionController)
            controller.provider = resolver.unravelComponent(ReviewsProvider.self,
                                                            argument: presenter as ReviewsPresentationLogic)
            return controller
        }
    }
    
    func registerRenderers(in container: DIContainer) {
        container.recordComponent(ReviewsRenderer.self) { (_, interaction: ReviewsUserInteraction) in
            ReviewsRenderer(interactional: interaction)
        }
    }

    func registerPresenter(in container: DIContainer) {
        container.recordComponent(ReviewsPresenter.self) { (_, view: ReviewsRenderingLogic, state: ReviewsModuleStateRepresentable) in
            ReviewsPresenter(view: view, state: state)
        }
    }

    func registerProvider(in container: DIContainer) {
        container.recordComponent(ReviewsProvider.self) { (resolver, presenter: ReviewsPresentationLogic) in
            ReviewsProvider(presenter: presenter,
                            previewsService: PreviewsServiceResolver(resolver).unravel())
        }
    }
    
    func registerRouter(in container: DIContainer) {
        container.recordComponent(ReviewsRouter.self) { (_, transitionController: TransitionController) in
            ReviewsRouter(transitionController: transitionController)
        }
    }
}
