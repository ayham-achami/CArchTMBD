//
//  ProfileImagesView.swift
//

import CArch
import CUIKit
import TMDBUIKit
import UIKit

// MARK: - Delegate
protocol ProfileImagesViewDelegate: AnyObject {
    
    func profileImagesView(_ profileImagesView: ProfileImagesView, didSelectedImage path: String)
}

// MARK: - View
final class ProfileImagesView: UIView {
    
    typealias Model = [ProfileImagesCell.Model]
    
    private lazy var layout: CarouselCollectionViewLayout = {
        let layout = CarouselCollectionViewLayout()
        layout.sideItemAlpha = 0.8
        layout.sideItemScale = 0.5
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: 300, height: 450)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(factory: ProfileImagesCellFactory.self)
        return view
    }()
    
    private var content: [ProfileImagesCell.Model] = []
    
    weak var delegate: ProfileImagesViewDelegate?
    
    var contentInset: UIEdgeInsets {
        get {
            collectionView.contentInset
        }
        set {
            collectionView.contentInset = newValue
            collectionView.scrollIndicatorInsets = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        rendering()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        rendering()
    }
    
    func set(content: [ProfileImagesCell.Model]) {
        self.content = content
        collectionView.reloadData()
    }
    
    func rendering() {
        backgroundColor = .clear
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: - ProfileImagesView + UICollectionViewDataSource
extension ProfileImagesView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        content.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(by: ProfileImagesCellFactory.self, for: indexPath, models: content)
    }
}

// MARK: - ProfileImagesView + UICollectionViewDelegate
extension ProfileImagesView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.profileImagesView(self, didSelectedImage: content[indexPath.row].path)
    }
}

#if DEBUG
#Preview(String(describing: ProfileImagesView.self)) {
    let preview = ProfileImagesView(frame: .zero)
    // preview.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
    preview.set(content: (1...10).map { _ in
            .init(path: "/llkbyWKwpfowZ6C8peBjIV9jj99.jpg")
    })
    preview.translatesAutoresizingMaskIntoConstraints = false
    let vc = UIViewController()
    vc.view.addSubview(preview)
    NSLayoutConstraint.activate([preview.heightAnchor.constraint(equalToConstant: 400),
                                 preview.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor),
                                 preview.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
                                 preview.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor)])
    return vc
}
#endif
