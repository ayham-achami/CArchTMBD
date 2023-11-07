//
//  BiographyView.swift
//

import CArch
import TMDBUIKit
import UIKit

final class BiographyView: CardView {
    
    struct Model: UIModel {
        
        let knownAs: String
        let biography: String
    }
    
    private let biographyView: VerticalSubtitleView = {
        let view = VerticalSubtitleView()
        view.titleLabel.text = "Biography"
        view.titleLabel.font = UIFont.Bold.body1
        view.subtitleLabel.font = UIFont.Regular.body2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let knownAsView: VerticalSubtitleView = {
        let view = VerticalSubtitleView()
        view.titleLabel.text = "Also Known As"
        view.titleLabel.font = UIFont.Bold.body1
        view.subtitleLabel.font = UIFont.Regular.body2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func set(content: Model) {
        knownAsView.subtitleLabel.text = content.knownAs
        biographyView.subtitleLabel.text = content.biography
    }
    
    override func rendering() {
        super.rendering()
        contentView.addSubview(biographyView)
        NSLayoutConstraint.activate([
            biographyView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            biographyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            biographyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
        
        contentView.addSubview(knownAsView)
        NSLayoutConstraint.activate([
            knownAsView.topAnchor.constraint(equalTo: biographyView.bottomAnchor, constant: 8),
            knownAsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            knownAsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            knownAsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
}

#if DEBUG
#Preview(String(describing: OverviewView.self)) {
    let preview = BiographyView(frame: .zero)
    preview.set(content: .init(knownAs: "Марго Роббі Марго Робби มาร์โก ร็อบบี 瑪歌·羅比 마고 로비",
                               biography: "The story of J. Robert Oppenheimer’s role in the development of the atomic bomb during World War II."))
    preview.translatesAutoresizingMaskIntoConstraints = false
    let vc = UIViewController()
    vc.view.addSubview(preview)
    NSLayoutConstraint.activate([preview.widthAnchor.constraint(equalToConstant: 300),
                                 preview.heightAnchor.constraint(equalToConstant: 300),
                                 preview.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
                                 preview.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor)])
    return vc
}
#endif
