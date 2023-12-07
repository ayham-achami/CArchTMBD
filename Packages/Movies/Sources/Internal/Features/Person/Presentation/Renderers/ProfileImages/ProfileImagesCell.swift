//
//  ProfileImagesCell.swift
//

import AlamofireImage
import CArch
import CUIKit
import TMDBUIKit
import UIKit

struct ProfileImagesCellFactory: UIReusableViewFactory {
    
    typealias View = ProfileImagesCell
    typealias Model = ProfileImagesCell.Model
    
    private let model: Model
    
    init(_ model: ProfileImagesCell.Model) {
        self.model = model
    }
    
    func rendering(_ view: ProfileImagesCell) {
        view.set(content: model)
    }
}

class ProfileImagesCell: UICollectionViewCell {
    
    struct Model: ViewModel {
    
        let path: String
    }
    
    private let posterBaseURL: URL = {
        .init(string: "https://www.themoviedb.org/t/p/w342")!
    }()
    
    private let cardView: CardView = {
        let view = CardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let portraitImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        rendering()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        rendering()
    }
    
    func set(content: Model) {
        portraitImageView.setImage(with: posterBaseURL, path: content.path, showLoader: true)
    }
    
    func rendering() {
        addSubview(cardView)
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: topAnchor),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        cardView.effectView.blur.contentView.addSubview(portraitImageView)
        NSLayoutConstraint.activate([
            portraitImageView.topAnchor.constraint(equalTo: cardView.effectView.blur.topAnchor),
            portraitImageView.bottomAnchor.constraint(equalTo: cardView.effectView.blur.bottomAnchor),
            portraitImageView.leadingAnchor.constraint(equalTo: cardView.effectView.blur.leadingAnchor),
            portraitImageView.trailingAnchor.constraint(equalTo: cardView.effectView.blur.trailingAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        portraitImageView.cancelImageLoading()
        portraitImageView.image = nil
    }
}

#if DEBUG
#Preview(String(describing: ProfileImagesCell.self)) {
    let preview = ProfileImagesCell(frame: .zero)
    preview.set(content: .init(path: "/llkbyWKwpfowZ6C8peBjIV9jj99.jpg"))
    preview.translatesAutoresizingMaskIntoConstraints = false
    let vc = UIViewController()
    vc.view.addSubview(preview)
    NSLayoutConstraint.activate([preview.widthAnchor.constraint(equalToConstant: 200),
                                 preview.heightAnchor.constraint(equalToConstant: 300),
                                 preview.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
                                 preview.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor)])
    return vc
}
#endif
