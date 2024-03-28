//
//  VideoCollectionViewLayout.swift
//

import UIKit

final class VideoCollectionViewLayout: UICollectionViewFlowLayout {
    
    var spacing: CGFloat = 10
    var sideItemScale: CGFloat = 0.1
    var sideItemAlpha: CGFloat = 0.5
    
    var scaledItemOffset: CGFloat {
        switch scrollDirection {
        case .vertical:
            return (itemSize.height - (itemSize.height * (sideItemScale + (1 - sideItemScale) / 2))) / 2
        case .horizontal:
            return (itemSize.width - (itemSize.width * (sideItemScale + (1 - sideItemScale) / 2))) / 2
        @unknown default:
            preconditionFailure("Unknown scroll direction \(scrollDirection)")
        }
    }
    
    override func prepare() {
        guard  let collectionView else {return}
        let xInset = (collectionView.bounds.width - itemSize.width) / 2
        let yInset = (collectionView.bounds.height - itemSize.height) / 2
        sectionInset = .init(top: yInset, left: xInset, bottom: yInset, right: xInset)
        
        switch scrollDirection {
        case .vertical:
            minimumLineSpacing = spacing - scaledItemOffset
        case .horizontal:
            minimumLineSpacing = spacing - scaledItemOffset
        @unknown default:
            preconditionFailure("Unknown scroll direction \(scrollDirection)")
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard
            let superAttributes = super.layoutAttributesForElements(in: rect),
            let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes]
        else { return nil }
        return attributes.map(transformLayoutAttributes(attributes:))
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                      withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard
            let collectionView
        else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity) }

        switch scrollDirection {
        case .vertical:
            return verticalContentOffset(collectionView, proposedContentOffset)
        case .horizontal:
            return horizontalContentOffset(collectionView, proposedContentOffset)
        @unknown default:
            preconditionFailure("Unknown scroll direction \(scrollDirection)")
        }
    }
    
    private func transformLayoutAttributes(attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        switch scrollDirection {
        case .vertical:
            return verticalAttributes(attributes)
        case .horizontal:
            return horizontalAttributes(attributes)
        @unknown default:
            preconditionFailure("Unknown scroll direction \(scrollDirection)")
        }
    }
    
    private func verticalAttributes(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard  let collectionView else { return attributes }
        let collectionCenter = collectionView.frame.size.height / 2
        let contentOffset = collectionView.contentOffset.y
        let center = attributes.center.y - contentOffset
        
        let maxDistance = 2 * (itemSize.height + minimumLineSpacing)
        let distance = min(abs(collectionCenter - center), maxDistance)

        let ratio = (maxDistance - distance) / maxDistance

        let alpha = ratio * (1 - sideItemAlpha) + sideItemAlpha
        let scale = ratio * (1 - sideItemScale) + sideItemScale
        
        attributes.alpha = alpha
        if abs(collectionCenter - center) > maxDistance + 1 {
            attributes.alpha = 0
        }
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let distanceY = attributes.frame.midY + visibleRect.midY
        let transform = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        attributes.transform3D = CATransform3DTranslate(transform, 0, 0, abs(distanceY / 1000))
        return attributes
    }
    
    private func horizontalAttributes(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard  let collectionView else { return attributes }
        let collectionCenter = collectionView.frame.size.width / 2
        let contentOffset = collectionView.contentOffset.x
        let center = attributes.center.x - contentOffset
        
        let maxDistance = 2 * (itemSize.width + minimumLineSpacing)
        let distance = min(abs(collectionCenter - center), maxDistance)

        let ratio = (maxDistance - distance) / maxDistance

        let alpha = ratio * (1 - sideItemAlpha) + sideItemAlpha
        let scale = ratio * (1 - sideItemScale) + sideItemScale
        
        attributes.alpha = alpha
        if abs(collectionCenter - center) > maxDistance + 1 {
            attributes.alpha = 0
        }
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let distanceX = attributes.frame.midX + visibleRect.midX
        let transform = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        attributes.transform3D = CATransform3DTranslate(transform, 0, 0, -abs(distanceX / 1000))
        return attributes
    }
    
    func verticalContentOffset(_ collectionView: UICollectionView, _ proposedContentOffset: CGPoint) -> CGPoint {
        let targetRect = CGRect(x: 0,
                                y: proposedContentOffset.y,
                                width: collectionView.frame.width,
                                height: collectionView.frame.height)
        guard
            let rectAttributes = super.layoutAttributesForElements(in: targetRect)
        else { return .zero }

        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalCenter = proposedContentOffset.y + collectionView.frame.height / 2
        for layoutAttributes in rectAttributes {
            let itemHorizontalCenter = layoutAttributes.center.y
            if (itemHorizontalCenter - horizontalCenter).magnitude < offsetAdjustment.magnitude {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }

        return CGPoint(x: proposedContentOffset.x, y: proposedContentOffset.y + offsetAdjustment)
    }
    
    func horizontalContentOffset(_ collectionView: UICollectionView, _ proposedContentOffset: CGPoint) -> CGPoint {
        let targetRect = CGRect(x: proposedContentOffset.x,
                                y: 0,
                                width: collectionView.frame.width, height: collectionView.frame.height)
        guard let rectAttributes = super.layoutAttributesForElements(in: targetRect) else { return .zero }

        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalCenter = proposedContentOffset.x + collectionView.frame.width / 2

        for layoutAttributes in rectAttributes {
            let itemHorizontalCenter = layoutAttributes.center.x
            if (itemHorizontalCenter - horizontalCenter).magnitude < offsetAdjustment.magnitude {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }

        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}
