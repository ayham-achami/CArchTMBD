//  ___FILEHEADER___

import UIKit
import CArch
import CArchSwinject

/// Протокол реализующий логику получения данных из слоя бизнес логики
@SyncAlias
protocol ___VARIABLE_productName___ProvisionLogic: RootProvisionLogic, ErrorAsyncHandler {}

/// Все взаимодействия пользователя с модулем
typealias ___VARIABLE_productName___UserInteraction = ___VARIABLE_productName___RendererUserInteraction // & <#SecondUserInteractionIfNeeded#>

/// Объект содержаний логику отображения данных
final class ___VARIABLE_productName___ViewController: UIViewController, ModuleLifeCycleOwner {

    // MARK: - Injected properties
    var router: ___VARIABLE_productName___RoutingLogic!
    var provider: ___VARIABLE_productName___ProvisionLogic!

    // MARK: - Injected Renderers
    var renderer: ___VARIABLE_productName___Renderer!

    /// состояние модуля `___VARIABLE_productName___`
    private var state = ___VARIABLE_productName___ModuleState()

    // MARK: - Lifecycle
    var lifeCycle: [ModuleLifeCycle] { [renderer] }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moduleDidLoad()
        
        view.addSubview(renderer)
        NSLayoutConstraint.activate([
            renderer.topAnchor.constraint(equalTo: view.topAnchor),
            renderer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            renderer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            renderer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
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

// MARK: - ___VARIABLE_productName___ + Initializer
extension ___VARIABLE_productName___ViewController: AnyModuleInitializer {
    
    func set<StateType>(initialState: StateType) where StateType: ModuleInitialState {
        state.initialState = initialState.is(___VARIABLE_productName___ModuleState.InitialStateType.self)
    }
}

// MARK: - ___VARIABLE_productName___ + StateRepresentable
extension ___VARIABLE_productName___ViewController: ___VARIABLE_productName___ModuleStateRepresentable {
    
    var readOnly: ___VARIABLE_productName___ModuleReadOnlyState {
    	state
    }
}

// MARK: - ___VARIABLE_productName___ + RenderingLogic
extension ___VARIABLE_productName___ViewController: ___VARIABLE_productName___RenderingLogic {}

// MARK: - ___VARIABLE_productName___ + UserInteraction
extension ___VARIABLE_productName___ViewController: ___VARIABLE_productName___UserInteraction {}

// MARK: - Preview
#Preview(String(describing: ___VARIABLE_productName___Module.self)) {
    ___VARIABLE_productName___Module.Builder().build().node
}
