//
//  RandomCellSizeLayout.swift
//  TMDB

import UIKit

final class RandomCellSizeLayout: UICollectionViewFlowLayout {
    
    private var contentWidth: CGFloat {
        guard let collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    private var itemWidth: CGFloat {
        contentWidth / 3
    }
    
    override var collectionViewContentSize: CGSize {
        .init(width: contentWidth, height: contentHeight)
    }
    
    private var contentHeight: CGFloat = 0
    private var calculatedAttributes = [UICollectionViewLayoutAttributes]()
    
    override func prepare() {
        guard let collectionView else { return }
        let count = 0..<collectionView.numberOfItems(inSection: 0)
        for index in count {
            let frame = CGRect(origin: itemOrigin(at: index), size: itemSize(at: index))
            let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: index, section: 0))
            attributes.frame = frame
            calculatedAttributes.append(attributes)
            contentHeight = max(contentHeight, frame.maxY)
        }
        super.prepare()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        calculatedAttributes.filter({ $0.frame.intersects(rect) })
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        calculatedAttributes[indexPath.item]
    }
    
    private func itemFrame(at index: Int) -> CGRect {
        .init(origin: itemOrigin(at: index), size: itemSize(at: index))
    }
    
    private func itemOrigin(at index: Int) -> CGPoint {
        .init(x: { () -> CGFloat in
            switch indexInsideGroup(of: index) {
            case 0, 2, 5:
                return 0
            case 1, 3, 6, 8:
                return itemWidth
            default:
                return itemWidth * 2
            }
        }(), y: { () -> CGFloat in
            let numberOfAboveGroups = index / 10
            let groupHeight = itemWidth * 4
            let aboveGroupsHeight = CGFloat(numberOfAboveGroups) * groupHeight
            let yOffsetInsideGroup: CGFloat = {
                switch indexInsideGroup(of: index) {
                case 0, 1, 4:
                    return 0
                case 2, 3:
                    return itemWidth
                case 5, 6, 7:
                    return itemWidth * 2
                default:
                    return itemWidth * 3
                }
            }()
            return aboveGroupsHeight + yOffsetInsideGroup
        }())
    }
    
    private func itemSize(at index: Int) -> CGSize {
        switch indexInsideGroup(of: index) {
        case 4, 5, 7:
            return .init(width: itemWidth, height: itemWidth * 2)
        default:
            return .init(width: itemWidth, height: itemWidth)
        }
    }
    
    private func indexInsideGroup(of index: Int) -> Int {
        index % 9
    }
}

#Preview(String(describing: WelcomeBackgroundRenderer.self)) {
    WelcomeBackgroundRenderer.preview()
}
