//  ___FILEHEADER___

import UIKit
import CArch

/// Протокол взаимодействия пользователя с модулем
protocol ___VARIABLE_productName___RendererUserInteraction: AnyUserInteraction {}

/// Объект содержащий логику отображения данных
final class ___VARIABLE_productName___Renderer: UIView, UIRenderer {
    
    // MARK: - Renderer model
    typealias ModelType = Model
    
    struct Model: UIModel {}

    // MARK: - Private properties
    private weak var interactional: ___VARIABLE_productName___RendererUserInteraction?
    
    // MARK: - Inits
    init(interactional: ___VARIABLE_productName___RendererUserInteraction) {
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
    func set(content: ___VARIABLE_productName___Renderer.ModelType) {}
}

// MARK: - Renderer + IBAction
private extension ___VARIABLE_productName___Renderer {}

// MARK: - Private methods
private extension ___VARIABLE_productName___Renderer {

    func rendering() {}
}

// MARK: - Preview
extension ___VARIABLE_productName___Renderer: UIRendererPreview {
    
    final class InteractionalPreview: ___VARIABLE_productName___RendererUserInteraction {}
    
    static let interactional: InteractionalPreview = .init()
    
    static func preview() -> Self {
        let preview = Self.init(interactional: interactional)
        preview.moduleDidLoad()
        return preview
    }
}

#if DEBUG
#Preview(String(describing: ___VARIABLE_productName___Renderer.self)) {
    ___VARIABLE_productName___Renderer.preview()
}
#endif
