//
//  MainView.swift
//

import CArch
import CArchSwinject
import Movies
import TMDBCore
import TMDBUIKit
import UIKit

/// Протокол реализующий логику получения данных из слоя бизнес логики
@SyncAlias
protocol MainProvisionLogic: RootProvisionLogic, ErrorAsyncHandler {}

/// Все взаимодействия пользователя с модулем
typealias MainUserInteraction = MainRendererUserInteraction

/// Объект содержаний логику отображения данных
final class MainViewController: UIViewController, ModuleLifeCycleOwner {

    // MARK: - Injected properties
    var router: MainRoutingLogic!
    var provider: MainProvisionLogic!

    // MARK: - Injected Renderers
    var renderer: MainRenderer!

    /// состояние модуля `Main`
    private var state = MainModuleState()

    // MARK: - Lifecycle
    var lifeCycle: [ModuleLifeCycle] { [renderer] }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.primaryBack.color
        
        let starter = PackageStarterBuilder
            .with(factory: LayoutAssemblyFactory.self)
            .build(starter: MoviesPackageStarter.self)
        
        let content = [
            starter.movies(.init(title: "Popular", icon: UIImage(systemName: "star.square")!, type: .popular)),
            starter.movies(.init(title: "Now Playing", icon: UIImage(systemName: "videoprojector")!, type: .nowPlaying)),
            starter.movies(.init(title: "Upcoming", icon: UIImage(systemName: "calendar")!, type: .upcoming)),
            starter.movies(.init(title: "Top Rated", icon: UIImage(systemName: "heart.square")!, type: .topRated))
        ]
        renderer.set(content: content)
        renderer.embed(into: self)
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

// MARK: - Main + Initializer
extension MainViewController: AnyModuleInitializer {
    
    func set<StateType>(initialState: StateType) where StateType: ModuleInitialState {
        state.initialState = initialState.is(MainModuleState.InitialStateType.self)
    }
}

// MARK: - Main + StateRepresentable
extension MainViewController: MainModuleStateRepresentable {
    
    var readOnly: MainModuleReadOnlyState {
    	state
    }
}

// MARK: - Main + RenderingLogic
extension MainViewController: MainRenderingLogic {}

// MARK: - Main + UserInteraction
extension MainViewController: MainUserInteraction {}

#if DEBUG
// MARK: - Preview
#Preview(String(describing: MainModule.self)) {
    MainModule.PreviewBuilder().build().node
}
#endif
