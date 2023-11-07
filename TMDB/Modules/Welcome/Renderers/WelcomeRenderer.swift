//
//  WelcomeRenderer.swift
//

import CArch
import TMDBUIKit
import UIKit

/// Протокол взаимодействия пользователя с модулем
protocol WelcomeRendererUserInteraction: AnyUserInteraction {
    
    /// <#Description#>
    func didRequestLogin()
    
    /// <#Description#>
    func didRequestDemo()
}

/// Объект содержащий логику отображения данных
final class WelcomeRenderer: UIView, UIRenderer {
    
    // MARK: - Renderer model
    typealias ModelType = Model
    private typealias PosterEffectView = (blur: UIVisualEffectView, vibrancy: UIVisualEffectView)
    
    struct Model: UIModel {}

    // MARK: - Private properties
    private weak var interactional: WelcomeRendererUserInteraction?
    
    private let effectView: PosterEffectView = {
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.contentView.addSubview(vibrancyView)
        return (blurEffectView, vibrancyView)
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor]
        gradientLayer.frame = .init(origin: .zero, size: .init(width: 2000, height: 2000))
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0) // 0 - 1
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.65)
        return gradientLayer
    }()
    
    private lazy var demoButton: UIButton = {
        var configuration = UIButton.Configuration.bordered()
        configuration.title = "Demo"
        
        var background = configuration.background
        background.cornerRadius = 5
        configuration.background = background
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapDemo), for: .touchUpInside)
        return button
    }()
    
    private lazy var loginButton: UIButton = {
        var configuration = UIButton.Configuration.bordered()
        configuration.title = "Login"
        
        var background = configuration.background
        background.cornerRadius = 5
        configuration.background = background
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        return button
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.Regular.headline
        label.text = "Movie browsing app using CArch 3.0 architecture"
        label.textColor = Colors.tmbd.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "CArch TMBD"
        label.font = UIFont.Bold.title1
        label.textColor = Colors.tmbd.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Inits
    init(interactional: WelcomeRendererUserInteraction) {
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
    
    func moduleLayoutSubviews() {
        gradientLayer.frame = bounds
    }
    
    // MARK: - Public methods
    func set(content: WelcomeRenderer.ModelType) {}
}

// MARK: - Renderer + IBAction
private extension WelcomeRenderer {
    
    @objc func didTapDemo() {
        interactional?.didRequestDemo()
    }
    
    @objc func didTapLogin() {
        interactional?.didRequestLogin()
    }
}

// MARK: - Private methods
private extension WelcomeRenderer {

    func rendering() {
        backgroundColor = .clear
        renderingEffectView()
        renderingButtons()
        renderingLabels()
    }
    
    func renderingEffectView() {
        NSLayoutConstraint.activate([
            effectView.vibrancy.topAnchor.constraint(equalTo: effectView.blur.topAnchor),
            effectView.vibrancy.bottomAnchor.constraint(equalTo: effectView.blur.bottomAnchor),
            effectView.vibrancy.leadingAnchor.constraint(equalTo: effectView.blur.leadingAnchor),
            effectView.vibrancy.trailingAnchor.constraint(equalTo: effectView.blur.trailingAnchor)
        ])
        
        addSubview(effectView.blur)
        NSLayoutConstraint.activate([
            effectView.blur.topAnchor.constraint(equalTo: topAnchor),
            effectView.blur.bottomAnchor.constraint(equalTo: bottomAnchor),
            effectView.blur.leadingAnchor.constraint(equalTo: leadingAnchor),
            effectView.blur.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        effectView.blur.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        effectView.blur.layer.mask = gradientLayer
    }
    
    func renderingButtons() {
        effectView.vibrancy.contentView.addSubview(loginButton)
        effectView.vibrancy.contentView.addSubview(demoButton)
        NSLayoutConstraint.activate([
            loginButton.heightAnchor.constraint(equalToConstant: 44),
            loginButton.bottomAnchor.constraint(equalTo: demoButton.topAnchor, constant: -16),
            loginButton.leadingAnchor.constraint(equalTo: effectView.vibrancy.contentView.layoutMarginsGuide.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: effectView.vibrancy.contentView.layoutMarginsGuide.trailingAnchor, constant: -16),
            demoButton.heightAnchor.constraint(equalToConstant: 44),
            demoButton.bottomAnchor.constraint(equalTo: effectView.vibrancy.contentView.layoutMarginsGuide.bottomAnchor),
            demoButton.leadingAnchor.constraint(equalTo: effectView.vibrancy.contentView.layoutMarginsGuide.leadingAnchor, constant: 16),
            demoButton.trailingAnchor.constraint(equalTo: effectView.vibrancy.contentView.layoutMarginsGuide.trailingAnchor, constant: -16)
        ])
    }
    
    func renderingLabels() {
        effectView.vibrancy.contentView.addSubview(titleLabel)
        effectView.vibrancy.contentView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: loginButton.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -16),
            
            titleLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -8)
        ])
        
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        descriptionLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        descriptionLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    }
}

#if DEBUG
// MARK: - Preview
extension WelcomeRenderer: UIRendererPreview {
    
    static func preview() -> Self {
        let preview = Self.init(interactional: InteractionalPreview.interactional)
        preview.moduleDidLoad()
        preview.moduleDidBecomeActive()
        return preview
    }
    
    final class InteractionalPreview: WelcomeRendererUserInteraction {
        
        static let interactional: InteractionalPreview = .init()
        
        func didRequestLogin() {
            print(#function)
        }
        
        func didRequestDemo() {
            print(#function)
        }
    }
}

#Preview(String(describing: WelcomeRenderer.self)) {
    let vc = UIViewController()
    let preview = WelcomeRenderer.preview()
    preview.translatesAutoresizingMaskIntoConstraints = false
    vc.view.addSubview(preview)
    NSLayoutConstraint.activate([
        preview.topAnchor.constraint(equalTo: vc.view.topAnchor),
        preview.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
        preview.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
        preview.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor)
    ])
    return vc
}
#endif
