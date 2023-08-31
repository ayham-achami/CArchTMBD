//
//  LoginRenderer.swift

import UIKit
import CArch
import TMDBUIKit

/// Протокол взаимодействия пользователя с модулем
protocol LoginRendererUserInteraction: AnyUserInteraction {
    
    /// <#Description#>
    /// - Parameters:
    ///   - login: <#login description#>
    ///   - password: <#password description#>
    func didRequestLogin(_ login: String, password: String)
}

/// Объект содержащий логику отображения данных 
final class LoginRenderer: UIScrollView, UIRenderer {
    
    // MARK: - Renderer model
    typealias ModelType = Model
    
    struct Model: UIModel {}

    // MARK: - Private properties
    private weak var interactional: LoginUserInteraction?
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = Images.tmdb.image
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var loginView: CredentialsView = {
        let view = CredentialsView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
private extension LoginRenderer {}

// MARK: - Private methods
private extension LoginRenderer {

    func rendering() {
        renderingContentView()
        renderingLogoImageView()
        renderingLoginView()
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
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func renderingLogoImageView() {
        contentView.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            logoImageView.heightAnchor.constraint(equalToConstant: 150),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
        ])
    }
    
    func renderingLoginView() {
        contentView.addSubview(loginView)
        NSLayoutConstraint.activate([
            loginView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),
            loginView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            loginView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            loginView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
}

extension LoginRenderer: CredentialsViewDelegate {
    
    func credentialsView(_ credentialsView: CredentialsView, didTapLoginWith login: String, and password: String) {
        interactional?.didRequestLogin(login, password: password)
    }
}

// MARK: - Preview
extension LoginRenderer: UIRendererPreview {
    
    final class InteractionalPreview: LoginUserInteraction {
        
        func didRequestLogin(_ login: String, password: String) {
            print(#function)
        }
    }
    
    static let interactional: InteractionalPreview = .init()
    
    static func preview() -> Self {
        let preview = Self.init(interactional: interactional)
        preview.moduleDidLoad()
        return preview
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
        preview.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
    ])
    return vc
}
