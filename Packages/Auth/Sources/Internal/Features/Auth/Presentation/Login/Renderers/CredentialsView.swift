//
//  CredentialsView.swift
//

import CArch
import TMDBUIKit
import UIKit

final class CredentialsView: CardView {
    
    struct Credentials {
        
        let login: String
        let password: String
    }
    
    struct CredentialsValidateOptions: OptionSet {
        
        let rawValue: UInt
        
        static let login = Self(rawValue: 1 << 0)
        static let password = Self(rawValue: 1 << 1)
        static let all: Self = [.login, .password]
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
        loginTextField.delegate = self
        passwordTextField.delegate = self
        renderingTextFields()
    }
    
    func set(credentialsValidate options: CredentialsValidateOptions) {
        if options.contains(.login) {
            loginTextField.showError(text: "Invalid login")
        }
        if options.contains(.password) {
            passwordTextField.showError(text: "Invalid password")
        }
    }
    
    private func renderingTextFields() {
        addSubview(loginTextField)
        addSubview(passwordTextField)
        let bottomConstraint = passwordTextField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        bottomConstraint.priority = .defaultLow
        NSLayoutConstraint.activate([
            loginTextField.topAnchor.constraint(equalTo: topAnchor, constant: 48),
            loginTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 48),
            loginTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            loginTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            bottomConstraint,
            passwordTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 48),
            passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 32)
        ])
    }
}

// MARK: - CredentialsView + UITextFieldDelegate
extension CredentialsView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        switch textField {
        case loginTextField where loginTextField.hintState == .error:
            loginTextField.hideError()
        case passwordTextField where passwordTextField.hintState == .error:
            passwordTextField.hideError()
        default:
            break
        }
        let inValidCharacterSet = CharacterSet.whitespacesAndNewlines
        guard let firstChar = string.unicodeScalars.first else { return true }
        return !inValidCharacterSet.contains(firstChar)
    }
}

#if DEBUG
// MARK: - Preview
#Preview(String(describing: CredentialsView.self)) {
    let vc = UIViewController()
    let preview = CredentialsView(frame: .zero)
    preview.translatesAutoresizingMaskIntoConstraints = false
    vc.view.addSubview(preview)
    NSLayoutConstraint.activate([
        preview.widthAnchor.constraint(equalToConstant: 300),
        preview.heightAnchor.constraint(equalToConstant: 200),
        preview.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
        preview.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor)
    ])
    return vc
}
#endif
