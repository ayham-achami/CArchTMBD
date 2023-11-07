//
//  LoginRenderer.swift
//

import CArch
import TMDBUIKit
import UIKit

/// Протокол взаимодействия пользователя с модулем
protocol LoginRendererUserInteraction: AnyUserInteraction {
    
    /// Вызывается при нажатии на кнопку логин
    /// - Parameters:
    ///   - login: Логин
    ///   - password: Пароль
    func didRequestLogin(_ login: String, _ password: String)
}

/// Объект содержащий логику отображения данных
final class LoginRenderer: UIScrollView, UIRenderer {
    
    // MARK: - Renderer model
    typealias ModelType = Model
    private typealias PosterEffectView = (blur: UIVisualEffectView, vibrancy: UIVisualEffectView)
    
    struct Model: UIModel {}

    // MARK: - Private properties
    private weak var interactional: LoginUserInteraction?
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = Images.background.image
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var logoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = Images.tmdb.image
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var effectView: PosterEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.contentView.addSubview(vibrancyView)
        return (blurEffectView, vibrancyView)
    }()
    
    private lazy var credentialsView: CredentialsView = {
        let view = CredentialsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var loginButton: UIButton = {
        var configuration = UIButton.Configuration.bordered()
        configuration.title = "Login"
        var background = configuration.background
        background.cornerRadius = 5
        configuration.background = background
        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Inits
    init(interactional: LoginUserInteraction) {
        super.init(frame: .zero)
        self.interactional = interactional
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    func moduleDidLoad() {
        rendering()
    }
    
    // MARK: - Public methods
    func set(content: LoginRenderer.ModelType) {}
}

// MARK: - Renderer + IBAction
private extension LoginRenderer {
    
    @objc private func didTapLogin() {
        guard validate(credentialsView.credentials) else { return }
        interactional?.didRequestLogin(credentialsView.credentials.login,
                                       credentialsView.credentials.password)
    }
}

// MARK: - Private methods
private extension LoginRenderer {

    func rendering() {
        renderingContentView()
        renderingBackgroundImageView()
        renderingEffectView()
        renderingLogoImageView()
        renderingCredentialsView()
        renderingLoginButton()
    }
    
    func renderingContentView() {
        addSubview(contentView)
        let heightConstraint = contentView.heightAnchor.constraint(equalTo: heightAnchor)
        heightConstraint.priority = .defaultLow
        NSLayoutConstraint.activate([
            heightConstraint,
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func renderingBackgroundImageView() {
        insertSubview(backgroundImageView, belowSubview: contentView)
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: frameLayoutGuide.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: frameLayoutGuide.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: frameLayoutGuide.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: frameLayoutGuide.trailingAnchor)
        ])
    }
    
    func renderingEffectView() {
        NSLayoutConstraint.activate([
            effectView.vibrancy.topAnchor.constraint(equalTo: effectView.blur.topAnchor),
            effectView.vibrancy.bottomAnchor.constraint(equalTo: effectView.blur.bottomAnchor),
            effectView.vibrancy.leadingAnchor.constraint(equalTo: effectView.blur.leadingAnchor),
            effectView.vibrancy.trailingAnchor.constraint(equalTo: effectView.blur.trailingAnchor)
        ])
        
        contentView.addSubview(effectView.blur)
        NSLayoutConstraint.activate([
            effectView.blur.topAnchor.constraint(equalTo: frameLayoutGuide.topAnchor),
            effectView.blur.bottomAnchor.constraint(equalTo: frameLayoutGuide.bottomAnchor),
            effectView.blur.leadingAnchor.constraint(equalTo: frameLayoutGuide.leadingAnchor),
            effectView.blur.trailingAnchor.constraint(equalTo: frameLayoutGuide.trailingAnchor)
        ])
        
        effectView.blur.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func renderingLogoImageView() {
        effectView.vibrancy.contentView.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            logoImageView.heightAnchor.constraint(equalToConstant: 150),
            logoImageView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor, constant: 32),
            logoImageView.centerXAnchor.constraint(equalTo: effectView.vibrancy.contentView.centerXAnchor)
        ])
    }
    
    func renderingCredentialsView() {
        contentView.addSubview(credentialsView)
        let leadingConstraint = credentialsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        leadingConstraint.priority = .defaultHigh
        let trailingConstraint =  credentialsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        trailingConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            leadingConstraint,
            trailingConstraint,
            credentialsView.widthAnchor.constraint(lessThanOrEqualToConstant: 472),
            credentialsView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
            credentialsView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            credentialsView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 32)
        ])
    }
    
    func renderingLoginButton() {
        effectView.vibrancy.contentView.addSubview(loginButton)
        let bottomConstraint = loginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        bottomConstraint.priority = .defaultLow
        NSLayoutConstraint.activate([
            bottomConstraint,
            loginButton.heightAnchor.constraint(equalToConstant: 48),
            loginButton.leadingAnchor.constraint(equalTo: credentialsView.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: credentialsView.trailingAnchor),
            loginButton.topAnchor.constraint(equalTo: credentialsView.bottomAnchor, constant: 16)
        ])
    }
    
    func validate(_ credentials: CredentialsView.Credentials) -> Bool {
        switch (credentials.login.isEmpty, credentials.password.isEmpty) {
        case (true, true):
            credentialsView.set(credentialsValidate: .all)
        case (true, _):
            credentialsView.set(credentialsValidate: .login)
        case (_, true):
            credentialsView.set(credentialsValidate: .password)
        default:
            return true
        }
        return false
    }
}

#if DEBUG
// MARK: - Preview
extension LoginRenderer: UIRendererPreview {

    static func preview() -> Self {
        let preview = Self.init(interactional: InteractionalPreview.interactional)
        preview.moduleDidLoad()
        return preview
    }
    
    final class InteractionalPreview: LoginUserInteraction {
     
        static let interactional: InteractionalPreview = .init()
        
        func didRequestLogin(_ login: String, _ password: String) {
            print(#function)
        }
    }
}

#Preview(String(describing: LoginRenderer.self)) {
    let vc = UIViewController()
    let preview = LoginRenderer.preview()
    preview.translatesAutoresizingMaskIntoConstraints = false
    vc.view.addSubview(preview)
    NSLayoutConstraint.activate([
        preview.topAnchor.constraint(equalTo: vc.view.topAnchor),
        preview.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
        preview.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
        preview.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor)
    ])
    let nc = UINavigationController(rootViewController: vc)
    return nc
}
#endif
