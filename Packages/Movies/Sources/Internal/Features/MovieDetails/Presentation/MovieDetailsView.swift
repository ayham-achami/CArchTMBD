//  
//  MovieDetailsView.swift

import UIKit
import CArch
import CArchSwinject

/// Протокол реализующий логику получения данных из слоя бизнес логики
@SyncAlias
protocol MovieDetailsProvisionLogic: RootProvisionLogic, ErrorAsyncHandler {
    
    /// <#Description#>
    /// - Parameter id: <#id description#>
    func obtainMovieDetails(with id: Int) async throws
}

/// Все взаимодействия пользователя с модулем
typealias MovieDetailsUserInteraction = MovieDetailsRendererUserInteraction & MovieDetailsNavigationRendererUserInteraction

/// Объект содержаний логику отображения данных
final class MovieDetailsViewController: UIViewController, ModuleLifeCycleOwner {

    // MARK: - Injected properties
    var router: MovieDetailsRoutingLogic!
    var provider: MovieDetailsProvisionLogic!

    // MARK: - Injected Renderers
    var renderer: MovieDetailsRenderer!
    var navigationRenderer: MovieDetailsNavigationRenderer!

    /// состояние модуля `MovieDetails`
    private var state = MovieDetailsModuleState()

    // MARK: - Lifecycle
    var lifeCycle: [ModuleLifeCycle] { [renderer, navigationRenderer] }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moduleDidLoad()
        
        view.addSubview(renderer)
        renderer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            renderer.topAnchor.constraint(equalTo: view.topAnchor),
            renderer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            renderer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            renderer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.addSubview(navigationRenderer)
        navigationRenderer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationRenderer.widthAnchor.constraint(equalToConstant: 30),
            navigationRenderer.heightAnchor.constraint(equalToConstant: 30),
            navigationRenderer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            navigationRenderer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32)
        ])
        
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
        renderer.set(content: details)
    }
}

// MARK: - MovieDetails + UserInteraction
extension MovieDetailsViewController: MovieDetailsUserInteraction {
    
    func didRequestPersonDetails(with id: Int) {
        router.showPersoneDetailes(.init(id: id))
    }
    
    func didRequestClose() {
        router.closeModule()
    }
}

// MARK: - Preview
#Preview(String(describing: MovieDetailsModule.self)) {
    MovieDetailsModule.PreviewBuilder().build().node
}
