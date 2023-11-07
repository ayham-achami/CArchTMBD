//
//  ReviewsView.swift
//

import AsyncDisplayKit
import CArch
import CArchSwinject
import UIKit

/// Протокол реализующий логику получения данных из слоя бизнес логики
@SyncAlias
protocol ReviewsProvisionLogic: RootProvisionLogic, ErrorAsyncHandler {
    
    /// <#Description#>
    /// - Parameter id: <#id description#>
    func obtainReviews(for id: Int) async throws
}

/// Все взаимодействия пользователя с модулем
typealias ReviewsUserInteraction = ReviewsRendererUserInteraction

/// Объект содержаний логику отображения данных
final class ReviewsViewController: UIViewController, ModuleLifeCycleOwner {

    // MARK: - Injected properties
    var router: ReviewsRoutingLogic!
    var provider: ReviewsProvisionLogic!

    // MARK: - Injected Renderers
    var renderer: ReviewsRenderer!

    /// состояние модуля `Reviews`
    private var state = ReviewsModuleState()

    // MARK: - Lifecycle
    var lifeCycle: [ModuleLifeCycle] { [renderer] }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moduleDidLoad()
        view.addSubview(renderer.view)
        renderer.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            renderer.view.topAnchor.constraint(equalTo: view.topAnchor),
            renderer.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            renderer.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            renderer.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        provider.obtainReviews(for: state.initial.id)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        moduleLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        moduleDidBecomeActive()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        moduleDidResignActive()
    }
}

// MARK: - Reviews + Initializer
extension ReviewsViewController: AnyModuleInitializer {
    
    func set<StateType>(initialState: StateType) where StateType: ModuleInitialState {
        state.initialState = initialState.is(ReviewsModuleState.InitialStateType.self)
    }
}

// MARK: - Reviews + StateRepresentable
extension ReviewsViewController: ReviewsModuleStateRepresentable {
    
    var readOnly: ReviewsModuleReadOnlyState {
    	state
    }
}

// MARK: - Reviews + RenderingLogic
extension ReviewsViewController: ReviewsRenderingLogic {
    
    func display(_ reviews: ReviewsRenderer.ModelType) {
        renderer.set(content: reviews)
    }
}

// MARK: - Reviews + UserInteraction
extension ReviewsViewController: ReviewsUserInteraction {}

#if DEBUG
// MARK: - Preview
#Preview(String(describing: ReviewsModule.self)) {
    ReviewsModule.PreviewBuilder().build().node
}
#endif
