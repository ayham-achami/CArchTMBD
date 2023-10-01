//
//  TitleView.swift

import UIKit
import CArch
import TMDBUIKit

final class TitleView: CardView {
    
    struct Model: UIModel {
        
        let rating: Float
        let title: String
        let genres: String
        let tagline: String
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.Bold.title2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let taglineLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.Regular.body2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let genresLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.Regular.body2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
        titleLabel.text = content.title
        genresLabel.text = content.genres
        taglineLabel.text = content.tagline
        
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
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
        
        effectView.blur.contentView.addSubview(ratingView)
        NSLayoutConstraint.activate([
            ratingView.widthAnchor.constraint(equalToConstant: 50),
            ratingView.heightAnchor.constraint(equalToConstant: 50),
            ratingView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            ratingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            ratingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        stackView.addArrangedSubview(genresLabel)
        stackView.addArrangedSubview(taglineLabel)
        
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: ratingView.leadingAnchor, constant: -16)
        ])
    }
}

#if DEBUG
// MARK: - Preview
#Preview(String(describing: TitleView.self)) {
    let preview = TitleView(frame: .zero)
    preview.set(content: .init(rating: 0.7,
                               title: "Oppenheimer ",
                               genres: "Drama, History",
                               tagline: "The world forever changes."))
    preview.translatesAutoresizingMaskIntoConstraints = false
    let vc = UIViewController()
    vc.view.addSubview(preview)
    NSLayoutConstraint.activate([preview.widthAnchor.constraint(equalToConstant: 300),
                                 preview.heightAnchor.constraint(equalToConstant: 100),
                                 preview.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
                                 preview.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor)])
    return vc
}
#endif
