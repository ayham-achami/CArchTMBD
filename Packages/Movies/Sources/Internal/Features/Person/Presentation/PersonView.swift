//  
//  PersonView.swift
//  
//
//  Created by Ayham Hylam on 12.09.2023.
//

import UIKit
import CArch
import CArchSwinject

/// Протокол реализующий логику получения данных из слоя бизнес логики
@SyncAlias
protocol PersonProvisionLogic: RootProvisionLogic, ErrorAsyncHandler {
    
    func obtainPerson(with id: Int) async throws
}

/// Все взаимодействия пользователя с модулем
typealias PersonUserInteraction = PersonRendererUserInteraction

/// Объект содержаний логику отображения данных
final class PersonViewController: UIViewController, ModuleLifeCycleOwner {

    // MARK: - Injected properties
    var router: PersonRoutingLogic!
    var provider: PersonProvisionLogic!

    // MARK: - Injected Renderers
    var renderer: PersonRenderer!

    /// состояние модуля `Person`
    private var state = PersonModuleState()

    // MARK: - Lifecycle
    var lifeCycle: [ModuleLifeCycle] { [renderer] }
    
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
    }
}

// MARK: - Person + UserInteraction
extension PersonViewController: PersonUserInteraction {}

// MARK: - Preview
#Preview(String(describing: PersonModule.self)) {
    PersonModule.PreviewBuilder().build().node
}
