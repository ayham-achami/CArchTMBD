//
//  CreditCell.swift
//

import AlamofireImage
import CArch
import TMDBUIKit
import UIKit

class CreditCell: UICollectionViewCell {
    
    struct Model: UIModel {
        
        let id: Int
        let name: String
        let character: String
        let posterPath: String
    }
    
    private let posterBaseURL: URL = {
        .init(string: "https://www.themoviedb.org/t/p/w138_and_h175_face")!
    }()
    
    private let cardView: CardView = {
        let view = CardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let posterImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.Bold.caption1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let characterLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.Regular.caption1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        nameLabel.text = content.name
        characterLabel.text = content.character
        posterImageView.af.setImage(withURL: posterBaseURL.appending(path: content.posterPath))
    }
    
    func rendering() {
        addSubview(cardView)
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: topAnchor),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        cardView.effectView.blur.contentView.addSubview(posterImageView)
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: cardView.effectView.blur.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: cardView.effectView.blur.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: cardView.effectView.blur.trailingAnchor)
        ])
        
        cardView.contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: cardView.contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: cardView.contentView.trailingAnchor, constant: -8)
        ])
        
        cardView.contentView.addSubview(characterLabel)
        NSLayoutConstraint.activate([
            characterLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            characterLabel.leadingAnchor.constraint(equalTo: cardView.contentView.leadingAnchor, constant: 8),
            characterLabel.trailingAnchor.constraint(equalTo: cardView.contentView.trailingAnchor, constant: -8),
            characterLabel.bottomAnchor.constraint(equalTo: cardView.contentView.bottomAnchor, constant: -8)
        ])
    
        nameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        characterLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        characterLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.af.cancelImageRequest()
        posterImageView.image = nil
    }
}

#if DEBUG
// MARK: - Preview
#Preview(String(describing: CreditCell.self)) {
    let preview = CreditCell(frame: .zero)
    preview.set(content: .init(id: 0,
                               name: "Cillian Murphy",
                               character: "J. Robert Oppenheimer",
                               posterPath: "/llkbyWKwpfowZ6C8peBjIV9jj99.jpg"))
    preview.translatesAutoresizingMaskIntoConstraints = false
    let vc = UIViewController()
    vc.view.addSubview(preview)
    NSLayoutConstraint.activate([preview.widthAnchor.constraint(equalToConstant: 140),
                                 preview.heightAnchor.constraint(equalToConstant: 230),
                                 preview.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
                                 preview.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor)])
    
    return vc
}
#endif
