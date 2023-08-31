//
//  MoviesLayout.swift

import UIKit

final class MoviesLayout: UICollectionViewFlowLayout {

    let minCellHeight = CGFloat(250)
    let minColumnWidth = CGFloat(150)
    let insets = UIEdgeInsets(top: 0.0, left: 16, bottom: 0.0, right: 16)

    // MARK: Overrides
    override func prepare() {
        super.prepare()
        self.itemSize = calculateItemSize()
        self.sectionInset = insets
        self.sectionInsetReference = .fromSafeArea
        self.minimumLineSpacing = 25
    }
    
    func calculateItemSize() -> CGSize {
        guard let collectionView = collectionView else { return CGSize() }
        let availableWidth = collectionView.bounds.width
        let maxNumColumns = ((availableWidth - insets.left) / (minColumnWidth + insets.left)).rounded(.down)
        let cellWidth = ((availableWidth - insets.left) / maxNumColumns - insets.left).rounded(.down)
        let cellHeight = (minCellHeight * (cellWidth/minColumnWidth)).rounded(.down)
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
