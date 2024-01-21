//
//  ReviewsRenderer.swift
//

import AsyncDisplayKit
import CArch
import TMDBUIKit
import UIKit

/// Протокол взаимодействия пользователя с модулем
protocol ReviewsRendererUserInteraction: AnyUserInteraction {}

/// Объект содержащий логику отображения данных
final class ReviewsRenderer: ASDisplayNode, UIRenderer {
    
    // MARK: - Renderer model
    typealias ModelType = [ReviewNode.Model]

    // MARK: - Private properties
    private weak var interactional: ReviewsRendererUserInteraction?
    private var content: ModelType = []
    
    private lazy var collectionNode: ASCollectionNode = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        let collectionNode = ASCollectionNode(collectionViewLayout: layout)
        collectionNode.dataSource = self
        collectionNode.delegate = self
        collectionNode.inverted = true
        collectionNode.backgroundColor = .clear
        collectionNode.view.showsVerticalScrollIndicator = false
        return collectionNode
    }()
    
    // MARK: - Inits
    nonisolated init(interactional: ReviewsRendererUserInteraction) {
        super.init()
        automaticallyManagesSubnodes = true
        self.interactional = interactional
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    func moduleDidLoad() {
        backgroundColor = Colors.primaryBack.color
        rendering()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        ASWrapperLayoutSpec(layoutElement: collectionNode)
    }
    
    // MARK: - Public methods
    func set(content: ReviewsRenderer.ModelType) {
        self.content = content
        collectionNode.reloadData()
    }
}

// MARK: - Renderer + IBAction
private extension ReviewsRenderer {}

// MARK: - Private methods
private extension ReviewsRenderer {

    func rendering() {
    }
}

// MARK: - ReviewsRenderer + ASCollectionDataSource
extension ReviewsRenderer: ASCollectionDataSource {
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        content.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let model = content[indexPath.row]
        return { ReviewNode(model) }
    }
}

// MARK: - ReviewsRenderer + ASCollectionDelegate
extension ReviewsRenderer: ASCollectionDelegate {}

#if DEBUG
// MARK: - Preview
extension ReviewsRenderer: UIRendererPreview {
    
    static func preview() -> Self {
        let preview = Self.init(interactional: InteractionalPreview.interactional)
        preview.moduleDidLoad()
        preview.set(content: (1...10).map { id in
                .init(id: "64b9ba153009aa00ad6237a4\(id)",
                      author: "Manuel São Bento",
                      content: "Oppenheimer is a true masterclass in how to build extreme tension and suspense through fast",
                      createdAt: "08.08.08",
                      updatedAt: "08.08.08")
        })
        return preview
    }
    
    final class InteractionalPreview: ReviewsRendererUserInteraction {
        
        static let interactional: InteractionalPreview = .init()
    }
}

#Preview(String(describing: ReviewsRenderer.self)) {
    let vc = UIViewController()
    let preview = ReviewsRenderer.preview()
    // vc.view.addSubnode(preview)
    return vc
}
#endif
