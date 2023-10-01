//
//  MovieCell.swift

import UIKit
import CArch
import TMDBUIKit
import AlamofireImage

/// Объект содержащий логику отображения данных
final class MovieCell: UICollectionViewCell {
    
    struct Model: UIModel {
        
        let id: Int
        let name: String
        let rating: Float
        let posterPath: String
        let releaseDate: String
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .label
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .label
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let labelsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let ratingView: RatingView = {
        let view = RatingView(frame: .zero)
        view.lineWidth = 4
        view.ringWidth = 4
        view.grooveWidth = 4
        view.titleLabel.font = UIFont.Regular.caption2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let posterEffectImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private typealias PosterEffectView = (blur: UIVisualEffectView, vibrancy: UIVisualEffectView)
    
    private let effectView: PosterEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.clipsToBounds = false
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.contentView.addSubview(vibrancyView)
        blurEffectView.clipsToBounds = false
        return (blurEffectView, vibrancyView)
    }()
    
    private let posterBaseURL: URL = {
        .init(string: "https://image.tmdb.org/t/p/w185")!
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        rendering()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        rendering()
    }
    
    // MARK: - Public methods
    func set(content: Model) {
        nameLabel.text = content.name
        dateLabel.text = content.releaseDate
        ratingView.setRating(text: content.rating)
        ratingView.setRating(content.rating, animated: true)
        posterImageView.setImage(with: posterBaseURL,
                                 path: content.posterPath,
                                 showLoader: true,
                                 union: posterEffectImageView)
    }
    
    func rendering() {
        backgroundColor = .clear
        clipsToBounds = true
        layer.cornerRadius = 12
        
        addSubview(posterImageView)
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50)
        ])
        
        addSubview(posterEffectImageView)
        NSLayoutConstraint.activate([
            posterEffectImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            posterEffectImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            posterEffectImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            posterEffectImageView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            effectView.vibrancy.topAnchor.constraint(equalTo: effectView.blur.topAnchor),
            effectView.vibrancy.bottomAnchor.constraint(equalTo: effectView.blur.bottomAnchor),
            effectView.vibrancy.leadingAnchor.constraint(equalTo: effectView.blur.leadingAnchor),
            effectView.vibrancy.trailingAnchor.constraint(equalTo: effectView.blur.trailingAnchor)
        ])
        
        posterEffectImageView.addSubview(effectView.blur)
        NSLayoutConstraint.activate([
            effectView.blur.topAnchor.constraint(equalTo: posterEffectImageView.topAnchor),
            effectView.blur.bottomAnchor.constraint(equalTo: posterEffectImageView.bottomAnchor),
            effectView.blur.leadingAnchor.constraint(equalTo: posterEffectImageView.leadingAnchor),
            effectView.blur.trailingAnchor.constraint(equalTo: posterEffectImageView.trailingAnchor)
        ])
        
        effectView.vibrancy.contentView.addSubview(ratingView)
        NSLayoutConstraint.activate([
            ratingView.widthAnchor.constraint(equalToConstant: 40),
            ratingView.heightAnchor.constraint(equalToConstant: 40),
            ratingView.centerYAnchor.constraint(equalTo: effectView.vibrancy.centerYAnchor),
            ratingView.trailingAnchor.constraint(equalTo: effectView.vibrancy.trailingAnchor, constant: -8)
        ])
        
        labelsStackView.addArrangedSubview(nameLabel)
        labelsStackView.addArrangedSubview(dateLabel)
        
        effectView.vibrancy.contentView.addSubview(labelsStackView)
        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: effectView.vibrancy.topAnchor, constant: 8),
            labelsStackView.bottomAnchor.constraint(equalTo: effectView.vibrancy.bottomAnchor, constant: -8),
            labelsStackView.leadingAnchor.constraint(equalTo: effectView.vibrancy.leadingAnchor, constant: 8),
            labelsStackView.trailingAnchor.constraint(equalTo: ratingView.leadingAnchor, constant: -8)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.cancelImageLoading()
        posterImageView.image = nil
        posterEffectImageView.cancelImageLoading()
        posterEffectImageView.image = nil
    }
}

#if DEBUG
#Preview(String(describing: MovieCell.self)) {
    let preview = MovieCell(frame: .zero)
    preview.set(content: .init(id: 0,
                               name: "John Wick: Chapter 4",
                               rating: 3.8,
                               posterPath: "/rktDFPbfHfUbArZ6OOOKsXcv0Bm.jpg",
                               releaseDate: "03/24/2023"))
    preview.translatesAutoresizingMaskIntoConstraints = false
    let vc = UIViewController()
    vc.view.addSubview(preview)
    NSLayoutConstraint.activate([preview.widthAnchor.constraint(equalToConstant: 300),
                                 preview.heightAnchor.constraint(equalToConstant: 600),
                                 preview.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
                                 preview.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor)])
    return vc
}
#endif
