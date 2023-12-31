//
//  CreditsView.swift
//

import CArch
import CUIKit
import TMDBUIKit
import UIKit

// MARK: - Delegate
protocol CreditsViewDelegate: AnyObject {
    
    /// Вызывается при выборе актера из списка
    /// - Parameters:
    ///   - creditsView: `CreditsView`
    ///   - id: Идентификатор актера
    func creditsView(_ creditsView: CreditsView, didSelectedPersone id: Int)
}

// MARK: - View
final class CreditsView: UIView {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(factory: CreditCellFactory.self)
        return view
    }()
    
    private var content: [CreditCell.Model] = []
    
    weak var delegate: CreditsViewDelegate?
    
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
    
    func set(content: [CreditCell.Model]) {
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

// MARK: - CreditsView + UICollectionViewDataSource
extension CreditsView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        content.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(by: CreditCellFactory.self, for: indexPath, models: content)
    }
}

// MARK: - CreditsView + UICollectionViewDelegateFlowLayout
extension CreditsView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: 140, height: 230)
    }
}

// MARK: - CreditsView + UICollectionViewDelegate
extension CreditsView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.creditsView(self, didSelectedPersone: content[indexPath.row].id)
    }
}

#if DEBUG
// MARK: - Preview
#Preview(String(describing: CreditsView.self)) {
    let preview = CreditsView(frame: .zero)
    preview.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
    preview.set(content: (1...10).map { id in
            .init(id: id,
                  name: "Cillian Murphy",
                  character: "J. Robert Oppenheimer",
                  posterPath: "/llkbyWKwpfowZ6C8peBjIV9jj99.jpg")
    })
    preview.translatesAutoresizingMaskIntoConstraints = false
    let vc = UIViewController()
    vc.view.addSubview(preview)
    NSLayoutConstraint.activate([preview.heightAnchor.constraint(equalToConstant: 300),
                                 preview.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor),
                                 preview.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
                                 preview.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor)])
    
    return vc
}
#endif
