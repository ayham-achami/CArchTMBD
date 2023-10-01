//  
//  PersonView.swift

import UIKit
import CArch
import CRest
import TMDBUIKit
import CArchSwinject

/// Протокол реализующий логику получения данных из слоя бизнес логики
@SyncAlias
protocol PersonProvisionLogic: RootProvisionLogic, ErrorAsyncHandler {
    
    /// Получить данные о персоне
    /// - Parameter id: Идентификатор персона
    func obtainPerson(with id: Int) async throws
}

/// Все взаимодействия пользователя с модулем
typealias PersonUserInteraction = PersonRendererUserInteraction & StateRendererUserInteraction

/// Объект содержаний логику отображения данных
final class PersonViewController: UIViewController, ModuleLifeCycleOwner {

    // MARK: - Injected properties
    var router: PersonRoutingLogic!
    var provider: PersonProvisionLogic!

    // MARK: - Injected Renderers
    var renderer: PersonRenderer!
    var stateRenderer: StateRenderer!

    /// состояние модуля `Person`
    private var state = PersonModuleState()

    // MARK: - Lifecycle
    var lifeCycle: [ModuleLifeCycle] { [renderer] }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moduleDidLoad()
        if presentingViewController != nil &&
            navigationController?.viewControllers.first === self {
            navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .close,
                                                      target: self,
                                                      action: #selector(didRequestClose))
        }
        
        view.addSubview(renderer)
        renderer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            renderer.topAnchor.constraint(equalTo: view.topAnchor),
            renderer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            renderer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            renderer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        stateRenderer.set(content: .init(state: .loading))
        contentUnavailableConfiguration = stateRenderer
        provider.obtainPerson(with: state.initial.id)
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

// MARK: - Person + Initializer
extension PersonViewController: AnyModuleInitializer {
    
    func set<StateType>(initialState: StateType) where StateType: ModuleInitialState {
        state.initialState = initialState.is(PersonModuleState.InitialStateType.self)
    }
}

// MARK: - Person + StateRepresentable
extension PersonViewController: PersonModuleStateRepresentable {
    
    var readOnly: PersonModuleReadOnlyState {
    	state
    }
}

// MARK: - Person + RenderingLogic
extension PersonViewController: PersonRenderingLogic {

    func display(_ model: PersonRenderer.ModelType) {
        renderer.set(content: model)
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

// MARK: - Person + UserInteraction
extension PersonViewController: PersonUserInteraction {
    
    @objc
    func didRequestClose() {
        router.closeModule()
    }
    
    func didAction(for state: StateRenderer.State) {
        guard case .error = state else { return }
        contentUnavailableConfiguration = stateRenderer
        provider.obtainPerson(with: self.state.initial.id)
    }
}

#if DEBUG
// MARK: - Preview
#Preview(String(describing: PersonModule.self)) {
    PersonModule.PreviewBuilder().build().node
}
#endif
