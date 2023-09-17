//
//  CredentialsView.swift

import UIKit
import CArch
import TMDBUIKit

final class CredentialsView: CardView {

    struct Credentials {
        
        let login: String
        let password: String
    }
    
    var credentials: Credentials {
        .init(login: loginTextField.text ?? "",
              password: passwordTextField.text ?? "")
    }
    
    private let loginTextField: TextField = {
        let field = TextField(frame: .zero)
        field.title = "Login"
        field.placeholder = "Enter login"
        field.tintColor = .white
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let passwordTextField: TextField = {
        let field = TextField(frame: .zero)
        field.title = "Password"
        field.placeholder = "Enter password"
        field.isSecureTextEntry = true
        field.tintColor = .white
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        rendering()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        rendering()
    }
    
    override func rendering() {
        super.rendering()
        renderingLoginTextField()
        renderingPasswordTextField()
    }
    
    private func renderingLoginTextField() {
        addSubview(loginTextField)
        NSLayoutConstraint.activate([
            loginTextField.heightAnchor.constraint(equalToConstant: 48),
            loginTextField.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            loginTextField.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            loginTextField.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 32),
        ])
    }
    
    private func renderingPasswordTextField() {
        addSubview(passwordTextField)
        NSLayoutConstraint.activate([
            passwordTextField.heightAnchor.constraint(equalToConstant: 48),
            passwordTextField.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 64)
        ])
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


