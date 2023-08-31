//
//  MainRenderer.swift
//  TMDB

import UIKit
import CArch
import TMDBUIKit

/// Протокол взаимодействия пользователя с модулем
protocol MainRendererUserInteraction: AnyUserInteraction {}

/// Объект содержащий логику отображения данных 
final class MainRenderer: UITabBarController, UIRenderer {
    
    // MARK: - Renderer model
    typealias ModelType = [CArchModule]

    // MARK: - Private properties
    private weak var interactional: MainUserInteraction?
    
    // MARK: - Inits
    init(interactional: MainUserInteraction) {
        super.init(nibName: nil, bundle: nil)
        self.interactional = interactional
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.primaryBack.color
        rendering()
    }
    
    // MARK: - Public methods
    func set(content: MainRenderer.ModelType) {
        viewControllers = content.map(\.node)
    }
}

// MARK: - Renderer + IBAction
private extension MainRenderer {}

// MARK: - Private methods
private extension MainRenderer {

    func rendering() {}
}

// MARK: - Preview
extension MainRenderer: UIRendererPreview {
    
    final class InteractionalPreview: MainUserInteraction {}
    
    static let interactional: InteractionalPreview = .init()
    
    static func preview() -> Self {
        let preview = Self.init(interactional: interactional)
        preview.moduleDidLoad()
        return preview
    }
}

#Preview(String(describing: MainRenderer.self)) {
    MainRenderer.preview()
}


