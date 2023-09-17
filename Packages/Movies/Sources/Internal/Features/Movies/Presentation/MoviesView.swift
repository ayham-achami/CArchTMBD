//
//  MoviesViewController.swift

import UIKit
import CArch
import TMDBUIKit
import CArchSwinject

/// Протокол реализующий логику получения данных из слоя бизнес логики
@SyncAlias
protocol MoviesProvisionLogic: RootProvisionLogic, ErrorAsyncHandler {
    
    /// Получить фильмы по странице
    /// - Parameters:
    ///   - type: Тип фильмов
    ///   - page: Номер страницы
    func obtainMovies(of type: MoviesModuleState.MoviesType, at page: Int) async throws
}

/// Все взаимодействия пользователя с модулем
typealias MoviesUserInteraction = MoviesRendererUserInteraction

/// Объект содержаний логику отображения данных
class MoviesViewController: UIViewController, ModuleLifeCycleOwner {

    private let moduleReference = assembly(MoviesAssembly.self)

    var moviesRenderer: MoviesRenderer!
    var provider: MoviesProvisionLogic!
    var router: MoviesRoutingLogic!

    var lifeCycle: [ModuleLifeCycle] { [moviesRenderer] }

    private var state = MoviesModuleState()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = state.initial.title
        view.backgroundColor = Colors.primaryBack.color
        
        moduleDidLoad()
        
        view.addSubview(moviesRenderer)
        moviesRenderer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moviesRenderer.topAnchor.constraint(equalTo: view.topAnchor),
            moviesRenderer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            moviesRenderer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            moviesRenderer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        provider.obtainMovies(of: state.initial.type, at: state.page)
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

// MARK: - AnyModuleInitializer
extension MoviesViewController: AnyModuleInitializer {

    func set<StateType>(initialState: StateType) where StateType: ModuleInitialState {
        state.initialState = initialState.is(MoviesModuleState.InitialStateType.self)
    }
}

// MARK: - Movies + Finalizer
extension MoviesViewController: AnyModuleFinalizer {

    func didFinalization<StateType>(with finalState: StateType) where StateType: ModuleFinalState {}
}

// MARK: - MoviesModuleStateRepresentable
extension MoviesViewController: MoviesModuleStateRepresentable {

    var readOnly: MoviesModuleReadOnlyState {
        state
    }
}

// MARK: - MoviesRenderingLogic
extension MoviesViewController: MoviesRenderingLogic {
    
    func display(_ movies: [MovieCell.Model]) {
        moviesRenderer.set(content: movies)
        state.page += 1
    }
}

// MARK: - MoviesUserInteraction
extension MoviesViewController: MoviesUserInteraction {
    
    func didRequestMoreMovies() {
        provider.obtainMovies(of: state.initial.type, at: state.page)
    }
    
    func didRequestMovieDetails(with id: Int) {
        router.showMovieDetails(.init(id: id))
    }
}

// MARK: - Preview
#Preview(String(describing: MoviesModule.self)) {
    MoviesModule.PreviewBuilder().build().node
}
