//
//  CredentialsView.swift

import UIKit
import CArch
import TMDBUIKit

protocol CredentialsViewDelegate: AnyObject {
    
    func credentialsView(_ credentialsView: CredentialsView, didTapLoginWith login: String, and password: String)
}

final class CredentialsView: UIView {
    
    private let loginTextField: TextField = {
        let field = TextField(frame: .infinite)
        field.title = "Login"
//        field.placeholder = "Enter login"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let passwordTextField: TextField = {
        let field = TextField(frame: .zero)
        field.title = "Password"
//        field.placeholder = "Enter password"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var loginButton: UIButton = {
        var configs = UIButton.Configuration.filled()
        configs.title = "Login"
        let button = UIButton(configuration: configs)
        button.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    weak var delegate: CredentialsViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        rendering()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        rendering()
    }
    
    private func rendering() {
        renderingLoginTextField()
        renderingPasswordTextField()
        renderingLoginButton()
    }
    
    private func renderingLoginTextField() {
        addSubview(loginTextField)
        NSLayoutConstraint.activate([
            loginTextField.heightAnchor.constraint(equalToConstant: 48),
            loginTextField.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            loginTextField.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            loginTextField.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    private func renderingPasswordTextField() {
        addSubview(passwordTextField)
        NSLayoutConstraint.activate([
            passwordTextField.heightAnchor.constraint(equalToConstant: 48),
            passwordTextField.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 55)
        ])
    }
    
    private func renderingLoginButton() {
        addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.heightAnchor.constraint(equalToConstant: 44),
            loginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginButton.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 32)
        ])
    }
    
    @objc private func didTapLogin() {
        delegate?.credentialsView(self, didTapLoginWith: loginTextField.text!, and: passwordTextField.text!)
    }
}

// MARK: - Preview
#Preview(String(describing: CredentialsView.self)) {
    let vc = UIViewController()
    let preview = CredentialsView(frame: .zero)
    preview.translatesAutoresizingMaskIntoConstraints = false
    vc.view.addSubview(preview)
    NSLayoutConstraint.activate([
        preview.widthAnchor.constraint(equalToConstant: 300),
        preview.heightAnchor.constraint(equalToConstant: 300),
        preview.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
        preview.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor),
    ])
    return vc
}


