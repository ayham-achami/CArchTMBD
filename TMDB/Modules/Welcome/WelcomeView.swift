//  
//  WelcomeView.swift
//  TMDB

import UIKit
import CArch
import Movies
import TMDBUIKit
import CArchSwinject

/// Протокол реализующий логику получения данных из слоя бизнес логики
@SyncAlias
protocol WelcomeProvisionLogic: RootProvisionLogic, ErrorAsyncHandler {
    
    func obtainPosters() async throws
}

/// Все взаимодействия пользователя с модулем
typealias WelcomeUserInteraction = WelcomeRendererUserInteraction & WelcomeBackgroundRendererUserInteraction

/// Объект содержаний логику отображения данных
final class WelcomeViewController: UIViewController, ModuleLifeCycleOwner {

    // MARK: - Injected properties
    var router: WelcomeRoutingLogic!
    var provider: WelcomeProvisionLogic!

    // MARK: - Injected Renderers
    var renderer: WelcomeRenderer!
    var backgroundRenderer: WelcomeBackgroundRenderer!

    /// состояние модуля `Welcome`
    private var state = WelcomeModuleState()

    // MARK: - Lifecycle
    var lifeCycle: [ModuleLifeCycle] { [renderer, backgroundRenderer] }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.primaryBack.color
        navigationController?.isNavigationBarHidden = true
        moduleDidLoad()
        
        view.addSubview(backgroundRenderer)
        backgroundRenderer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundRenderer.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundRenderer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundRenderer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundRenderer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        view.addSubview(renderer)
        renderer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            renderer.topAnchor.constraint(equalTo: view.topAnchor),
            renderer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            renderer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            renderer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        provider.obtainPosters()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        moduleLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        moduleDidBecomeActive()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        moduleDidResignActive()
    }
}

// MARK: - Welcome + Initializer
extension WelcomeViewController: AnyModuleInitializer {
    
    func set<StateType>(initialState: StateType) where StateType: ModuleInitialState {
        state.initialState = initialState.is(WelcomeModuleState.InitialStateType.self)
    }
}

// MARK: - Welcome + StateRepresentable
extension WelcomeViewController: WelcomeModuleStateRepresentable {
    
    var readOnly: WelcomeModuleReadOnlyState {
    	state
    }
}

// MARK: - Welcome + RenderingLogic
extension WelcomeViewController: WelcomeRenderingLogic {
    
    func display(_ posters: [String]) {
        backgroundRenderer.set(content: posters)
    }
}

// MARK: - Welcome + UserInteraction
extension WelcomeViewController: WelcomeUserInteraction {
    
    func didRequestDemo() {
        router.showMain(.init(title: "Demo", icon: UIImage(systemName: "star.square")!, type: .popular))
    }
    
    func didRequestLogin() {
        router.showLogin(.init())
    }
}

// MARK: - Preview
#Preview(String(describing: WelcomeModule.self)) {
    WelcomeModule.PreviewBuilder().build().node
}
