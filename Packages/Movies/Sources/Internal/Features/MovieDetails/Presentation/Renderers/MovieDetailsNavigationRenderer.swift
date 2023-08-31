//  
//  MovieDetailsNavigationRenderer.swift

import UIKit
import CArch
import TMDBUIKit

/// Протокол взаимодействия пользователя с модулем
protocol MovieDetailsNavigationRendererUserInteraction: AnyUserInteraction {
    
    /// <#Description#>
    func didRequestClose()
}

/// Объект содержащий логику отображения данных
final class MovieDetailsNavigationRenderer: UIView, UIRenderer {
    
    // MARK: - Renderer model
    typealias ModelType = Model
    
    struct Model: UIModel {}

    // MARK: - Private properties
    private weak var interactional: MovieDetailsNavigationRendererUserInteraction?
    
    private typealias EffectView = (blur: UIVisualEffectView, vibrancy: UIVisualEffectView)
    
    private let effectView: EffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.contentView.addSubview(vibrancyView)
        
        return (blurEffectView, vibrancyView)
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Images.cross.image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Inits
    init(interactional: MovieDetailsNavigationRendererUserInteraction) {
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
    func set(content: MovieDetailsNavigationRenderer.ModelType) {}
}

// MARK: - Renderer + IBAction
private extension MovieDetailsNavigationRenderer {
    
    @objc func didTapClose() {
        interactional?.didRequestClose()
    }
}

// MARK: - Private methods
private extension MovieDetailsNavigationRenderer {

    func rendering() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 5.0
        layer.cornerRadius = 15
                
        NSLayoutConstraint.activate([
            effectView.vibrancy.topAnchor.constraint(equalTo: effectView.blur.topAnchor),
            effectView.vibrancy.bottomAnchor.constraint(equalTo: effectView.blur.bottomAnchor),
            effectView.vibrancy.leadingAnchor.constraint(equalTo: effectView.blur.leadingAnchor),
            effectView.vibrancy.trailingAnchor.constraint(equalTo: effectView.blur.trailingAnchor)
        ])
        
        effectView.blur.layer.cornerRadius = 15
        effectView.blur.layer.masksToBounds = true
        
        addSubview(effectView.blur)
        NSLayoutConstraint.activate([
            effectView.blur.topAnchor.constraint(equalTo: topAnchor),
            effectView.blur.bottomAnchor.constraint(equalTo: bottomAnchor),
            effectView.blur.leadingAnchor.constraint(equalTo: leadingAnchor),
            effectView.blur.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        effectView.vibrancy.contentView.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: effectView.vibrancy.contentView.topAnchor),
            closeButton.bottomAnchor.constraint(equalTo: effectView.vibrancy.contentView.bottomAnchor),
            closeButton.leadingAnchor.constraint(equalTo: effectView.vibrancy.contentView.leadingAnchor),
            closeButton.trailingAnchor.constraint(equalTo: effectView.vibrancy.contentView.trailingAnchor),
        ])
    }
}

// MARK: - Preview
extension MovieDetailsNavigationRenderer: UIRendererPreview {
    
    final class InteractionalPreview: MovieDetailsNavigationRendererUserInteraction {
        
        func didRequestClose() {
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

#Preview(String(describing: MovieDetailsNavigationRenderer.self)) {
    MovieDetailsNavigationRenderer.preview()
}
