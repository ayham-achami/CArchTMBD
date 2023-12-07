//
//  WelcomeBackgroundRenderer.swift
//

import CArch
import Combine
import CUIKit
import UIKit

/// Протокол взаимодействия пользователя с модулем
protocol WelcomeBackgroundRendererUserInteraction: AnyUserInteraction {}

/// Объект содержащий логику отображения данных
final class WelcomeBackgroundRenderer: UICollectionView, UIRenderer {
    
    // MARK: - Renderer model
    typealias ModelType = [String]
    
    enum AnimationDirection {
        
        case up
        case down
    }
    
    // MARK: - Private properties
    private var content: ModelType = []
    private var subscription: AnyCancellable?
    private weak var interactional: WelcomeBackgroundRendererUserInteraction?
    
    private var shouldAnimate = false
    private var direction = AnimationDirection.up
    
    // MARK: - Inits
    init(interactional: WelcomeBackgroundRendererUserInteraction) {
        let layout = RandomCellSizeLayout()
        super.init(frame: .zero, collectionViewLayout: layout)
        self.interactional = interactional
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    func moduleDidLoad() {
        delegate = self
        dataSource = self
        contentInset = .zero
        isUserInteractionEnabled = false
        contentInsetAdjustmentBehavior = .never
        register(factory: WelcomeCellFactory.self)
        rendering()
    }
    
    func moduleDidBecomeActive() {
        shouldAnimate = true
        startScrolling()
    }
    
    func moduleDidResignActive() {
        shouldAnimate = false
    }
    
    // MARK: - Public methods
    func set(content: WelcomeBackgroundRenderer.ModelType) {
        self.content = content
        reloadData()
        scrollToItem(at: .init(row: content.count - 1, section: 0), at: .bottom, animated: false)
    }
}

// MARK: - Renderer + IBAction
private extension WelcomeBackgroundRenderer {}

// MARK: - Private methods
private extension WelcomeBackgroundRenderer {

    func rendering() {}
    
    func startScrolling() {
        let offset: CGFloat = 1
        var contentOffset = self.contentOffset
        switch direction {
        case .up:
            contentOffset.y += offset
        case .down:
            contentOffset.y -= offset
        }
        
        UIView.animate(withDuration: .init(offset / 10)) {
            self.contentOffset = contentOffset
        } completion: { _ in
            guard self.shouldAnimate else { return }
            self.startScrolling()
        }
    }
}

extension WelcomeBackgroundRenderer: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        content.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(by: WelcomeCellFactory.self, for: indexPath, models: content)
    }
}

extension WelcomeBackgroundRenderer: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            direction = .up
        } else if indexPath.row == content.count - 1 {
            direction = .down
        }
    }
}

#if DEBUG
// MARK: - Preview
extension WelcomeBackgroundRenderer: UIRendererPreview {
    
    static func preview() -> Self {
        let preview = Self.init(interactional: InteractionalPreview.interactional)
        preview.moduleDidLoad()
        let array = (1...20).map { id in
            ((id % 2) != 0) ? "/eeJjd9JU2Mdj9d7nWRFLWlrcExi.jpg" : "/4m1Au3YkjqsxF8iwQy0fPYSxE0h.jpg"
        }
        preview.set(content: array)
        preview.moduleDidBecomeActive()
        return preview
    }
    
    final class InteractionalPreview: WelcomeBackgroundRendererUserInteraction {
        
        static let interactional: InteractionalPreview = .init()
    }
}

#Preview(String(describing: WelcomeBackgroundRenderer.self)) {
    WelcomeBackgroundRenderer.preview()
}
#endif
