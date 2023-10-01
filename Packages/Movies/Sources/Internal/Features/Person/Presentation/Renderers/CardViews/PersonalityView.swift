//
//  PersonalityView.swift

import UIKit
import CArch
import TMDBUIKit

final class PersonalityView: CardView {
    
    struct Model: UIModel {
        
        let name: String
        let rating: Float
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.Bold.title1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingView: RatingView = {
        let view = RatingView()
        view.lineWidth = 4
        view.ringWidth = 4
        view.grooveWidth = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func set(content: Model) {
        nameLabel.text = content.name
        switch content.rating {
        case 0..<0.199:
            ratingView.startColor = Colors.red.color
            ratingView.endColor = Colors.red.color
        case 0.200..<0.499:
            ratingView.startColor = Colors.warn.color
            ratingView.endColor = Colors.warn.color
        default:
            ratingView.startColor = Colors.success.color
            ratingView.endColor = Colors.success.color
        }
        ratingView.setRating(text: content.rating)
        ratingView.setRating(content.rating, animated: true)
    }
    
    override func rendering() {
        super.rendering()
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
        
        effectView.blur.contentView.addSubview(ratingView)
        NSLayoutConstraint.activate([
            ratingView.widthAnchor.constraint(equalToConstant: 50),
            ratingView.heightAnchor.constraint(equalToConstant: 50),
            ratingView.centerXAnchor.constraint(equalTo: centerXAnchor),
            ratingView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            ratingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
}

#if DEBUG
#Preview(String(describing: PersonalityView.self)) {
    let preview = PersonalityView(frame: .zero)
    preview.set(content: .init(name: "Margot Robbie", rating: 0.7))
    preview.translatesAutoresizingMaskIntoConstraints = false
    let vc = UIViewController()
    vc.view.addSubview(preview)
    NSLayoutConstraint.activate([preview.widthAnchor.constraint(equalToConstant: 300),
                                 preview.heightAnchor.constraint(equalToConstant: 130),
                                 preview.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
                                 preview.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor)])
    return vc
}
#endif
