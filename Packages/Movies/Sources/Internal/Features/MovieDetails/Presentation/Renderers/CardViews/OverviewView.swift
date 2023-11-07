//
//  OverviewView.swift
//

import CArch
import TMDBUIKit
import UIKit

final class OverviewView: CardView {
    
    struct Model: UIModel {
        
        let overview: String
    }
    
    let subtitleView: VerticalSubtitleView = {
        let view = VerticalSubtitleView()
        view.titleLabel.text = "Overview: "
        view.titleLabel.font = UIFont.Bold.body2
        view.subtitleLabel.font = UIFont.Regular.body2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func set(content: Model) {
        subtitleView.subtitleLabel.text = content.overview
    }
    
    override func rendering() {
        super.rendering()
        contentView.addSubview(subtitleView)
        NSLayoutConstraint.activate([
            subtitleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            subtitleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            subtitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            subtitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
}

#if  DEBUG
// MARK: - Preview
#Preview(String(describing: OverviewView.self)) {
    let preview = OverviewView(frame: .zero)
    preview.set(content: .init(overview: "The story of J. Robert Oppenheimer’s role in the development of the atomic bomb during World War II."))
    preview.translatesAutoresizingMaskIntoConstraints = false
    let vc = UIViewController()
    vc.view.addSubview(preview)
    NSLayoutConstraint.activate([preview.widthAnchor.constraint(equalToConstant: 300),
                                 preview.heightAnchor.constraint(equalToConstant: 200),
                                 preview.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
                                 preview.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor)])
    return vc
}
#endif
