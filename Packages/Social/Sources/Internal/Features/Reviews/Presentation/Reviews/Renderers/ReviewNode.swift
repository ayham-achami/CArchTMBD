//
//  ReviewNode.swift
//  TMDB

import CArch
import UIKit
import AsyncDisplayKit

final class ReviewNode: ASCellNode {
    
    struct Model: UIModel {
        
        let id: String
        let author: String
        let content: String
        let createdAt: String
        let updatedAt: String
    }
    
    init(_ model: Model) {
        super.init()
        rendering(with: model)
        automaticallyManagesSubnodes = true
    }
    
    private let dateNode = ASTextNode()
    private let contentNode = ASTextNode()
    private let authorNode = ASTextNode()
    private let backgroundNode = ASDisplayNode()
    private let avatarNode = ASNetworkImageNode()
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let spacer = ASLayoutSpec()
        spacer.style.flexGrow = 1
        let headerStack = ASStackLayoutSpec(direction: .horizontal,
                                            spacing: 4,
                                            justifyContent: .start,
                                            alignItems: .notSet,
                                            children: [authorNode, spacer, dateNode])
        headerStack.style.flexShrink = 0.0
        let bubbleStack = ASStackLayoutSpec(direction: .vertical,
                                            spacing: 8,
                                            justifyContent: .spaceBetween,
                                            alignItems: .stretch,
                                            children: [headerStack])
        let insetSpec = ASInsetLayoutSpec(insets: .init(top: 8, left: 8, bottom: 8, right: 8), child: bubbleStack)
        let backgroundSpec = ASBackgroundLayoutSpec(child: insetSpec, background: backgroundNode)
        backgroundSpec.style.flexShrink = 1.0
        backgroundSpec.style.flexGrow = 0
        return backgroundSpec
    }
    
    private func rendering(with model: Model) {
        authorNode.attributedText = .init(string: model.author,
                                          attributes: [.foregroundColor: UIColor.label])
        dateNode.attributedText = .init(string: model.createdAt,
                                        attributes: [.foregroundColor: UIColor.label])
        contentNode.attributedText = .init(string: model.content,
                                           attributes: [.foregroundColor: UIColor.label])
    }
}

#Preview(String(describing: ReviewNode.self)) {
    let preview = ReviewNode(.init(id: "64b9ba153009aa00ad6237a4",
                                   author: "Manuel São Bento",
                                   content: "Oppenheimer is a true masterclass in how to build extreme tension and suspense through fast",
                                   createdAt: "08.08.08",
                                   updatedAt: "08.08.08"))
    preview.displaysAsynchronously = false
    ASDisplayNode.nonFatalErrorBlock = { error in
        print(error)
    }
    return ASDKViewController(node: preview)
}
