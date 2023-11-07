//
//  MovieDetailsView.swift
//

import CArch
import CArchSwinject
import TMDBUIKit
import UIKit

/// Протокол реализующий логику получения данных из слоя бизнес логики
@SyncAlias
protocol MovieDetailsProvisionLogic: RootProvisionLogic, ErrorAsyncHandler {
    
    /// Получить детали фильма
    /// - Parameter id: Идентификатор фильма
    func obtainMovieDetails(with id: Int) async throws
}

/// Все взаимодействия пользователя с модулем
typealias MovieDetailsUserInteraction = MovieDetailsRendererUserInteraction & StateRendererUserInteraction

/// Объект содержаний логику отображения данных
final class MovieDetailsViewController: UIViewController, ModuleLifeCycleOwner {

    // MARK: - Injected properties
    var router: MovieDetailsRoutingLogic!
    var provider: MovieDetailsProvisionLogic!

    // MARK: - Injected Renderers
    var stateRenderer: StateRenderer!
    var detailsRenderer: MovieDetailsRenderer!

    /// состояние модуля `MovieDetails`
    private var state = MovieDetailsModuleState()

    // MARK: - Lifecycle
    var lifeCycle: [ModuleLifeCycle] { [detailsRenderer] }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moduleDidLoad()
        
        if presentingViewController != nil &&
            navigationController?.viewControllers.first === self {
            navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .close,
                                                      target: self,
                                                      action: #selector(didRequestClose))
        }
        
        detailsRenderer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(detailsRenderer)
        NSLayoutConstraint.activate([
            detailsRenderer.topAnchor.constraint(equalTo: view.topAnchor),
            detailsRenderer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            detailsRenderer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailsRenderer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        stateRenderer.set(content: .init(state: .loading))
        contentUnavailableConfiguration = stateRenderer
        provider.obtainMovieDetails(with: state.initial.id)
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

// MARK: - MovieDetails + Initializer
extension MovieDetailsViewController: AnyModuleInitializer {
    
    func set<StateType>(initialState: StateType) where StateType: ModuleInitialState {
        state.initialState = initialState.is(MovieDetailsModuleState.InitialStateType.self)
    }
}

// MARK: - MovieDetails + StateRepresentable
extension MovieDetailsViewController: MovieDetailsModuleStateRepresentable {
    
    var readOnly: MovieDetailsModuleReadOnlyState {
    	state
    }
}

// MARK: - MovieDetails + RenderingLogic
extension MovieDetailsViewController: MovieDetailsRenderingLogic {
    
    func display(_ details: MovieDetailsRenderer.ModelType) {
        detailsRenderer.set(content: details)
        contentUnavailableConfiguration = nil
    }
    
    func display(errorDescription: String) {
        stateRenderer.set(content: .init(state: .error,
                                         image: .init(systemName: "exclamationmark.arrow.triangle.2.circlepath"),
                                         action: "Retry request",
                                         message: errorDescription))
        contentUnavailableConfiguration = stateRenderer
    }
}

// MARK: - MovieDetails + UserInteraction
extension MovieDetailsViewController: MovieDetailsUserInteraction {
    
    func didRequestPersonDetails(with id: Int) {
        router.showPersoneDetailes(.init(id: id))
    }
    
    @objc func didRequestClose() {
        router.closeModule()
    }
    
    func didAction(for state: StateRenderer.State) {
        guard case .error = state else { return }
        contentUnavailableConfiguration = stateRenderer
        provider.obtainMovieDetails(with: self.state.initial.id)
    }
}

#if DEBUG
// MARK: - Preview
#Preview(String(describing: MovieDetailsModule.self)) {
    MovieDetailsModule.PreviewBuilder().build().node
}
#endif
