//
//  WelcomeCell.swift
//

import AlamofireImage
import UIKit

final class WelcomeCell: UICollectionViewCell {
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
        
    private let posterBaseURL: URL = {
        .init(string: "https://image.tmdb.org/t/p/w1280")!
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
    func set(content: String) {
        posterImageView.af.setImage(withURL: posterBaseURL.appending(path: content))
    }
    
    func rendering() {
        backgroundColor = .clear
        addSubview(posterImageView)
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.af.cancelImageRequest()
        posterImageView.image = nil
    }
}

#if DEBUG
#Preview(String(describing: WelcomeCell.self)) {
    let preview = WelcomeCell(frame: .zero)
    preview.set(content: "/uS1AIL7I1Ycgs8PTfqUeN6jYNsQ.jpg")
    preview.translatesAutoresizingMaskIntoConstraints = false
    let vc = UIViewController()
    vc.view.addSubview(preview)
    NSLayoutConstraint.activate([preview.widthAnchor.constraint(equalToConstant: 100),
                                 preview.heightAnchor.constraint(equalToConstant: 150),
                                 preview.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
                                 preview.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor)])
    return vc
}
#endif
