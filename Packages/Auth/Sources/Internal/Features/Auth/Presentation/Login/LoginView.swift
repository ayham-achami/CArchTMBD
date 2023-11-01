//
//  LoginView.swift

import UIKit
import CArch
import TMDBUIKit
import CArchSwinject

/// Протокол реализующий логику получения данных из слоя бизнес логики
@SyncAlias
protocol LoginProvisionLogic: RootProvisionLogic, ErrorAsyncHandler {}

/// Все взаимодействия пользователя с модулем
typealias LoginUserInteraction = LoginRendererUserInteraction

/// Объект содержаний логику отображения данных
final class LoginViewController: UIViewController, ModuleLifeCycleOwner {

    // MARK: - Injected properties
    var router: LoginRoutingLogic!
    var provider: LoginProvisionLogic!

    // MARK: - Injected Renderers
    var renderer: LoginRenderer!

    /// состояние модуля `Login`
    private var state = LoginModuleState()
    private var keyboardHider: HideKeyboardWhenTappedAroundDelegate?

    // MARK: - Lifecycle
    var lifeCycle: [ModuleLifeCycle] { [renderer] }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.primaryBack.color
        moduleDidLoad()
        
        view.addSubview(renderer)
        renderer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            renderer.topAnchor.constraint(equalTo: view.topAnchor),
            renderer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            renderer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            renderer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        keyboardHider = hideKeyboardWhenTappedAround(exceptTypes: [UIButton.self, UITextField.self])
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

// MARK: - Login + Initializer
extension LoginViewController: AnyModuleInitializer {
    
    func set<StateType>(initialState: StateType) where StateType: ModuleInitialState {
        state.initialState = initialState.is(LoginModuleState.InitialStateType.self)
    }
}

// MARK: - Login + StateRepresentable
extension LoginViewController: LoginModuleStateRepresentable {
    
    var readOnly: LoginModuleReadOnlyState {
    	state
    }
}

// MARK: - Login + RenderingLogic
extension LoginViewController: LoginRenderingLogic {}

// MARK: - Login + UserInteraction
extension LoginViewController: LoginUserInteraction {
    
    func didRequestLogin(_ login: String, _ password: String) {
        router.showMain()
    }
}

#if DEBUG
 // MARK: - Preview
#Preview(String(describing: LoginModule.self)) {
    LoginModule.PreviewBuilder().build().node
}
#endif
