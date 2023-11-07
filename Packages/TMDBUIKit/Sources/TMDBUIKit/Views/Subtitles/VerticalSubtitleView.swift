//
//  VerticalSubtitleView.swift
//

import UIKit

public final class VerticalSubtitleView: UIView {
    
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        rendering()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        rendering()
    }
    
    public func rendering() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 28),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
        
        addSubview(subtitleLabel)
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
        
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        subtitleLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        subtitleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    }
}

#if DEBUG
#Preview(String(describing: VerticalSubtitleView.self)) {
    let preview = VerticalSubtitleView(frame: .zero)
    preview.titleLabel.text = "The FlashThe"
    preview.titleLabel.backgroundColor = .blue
    // swiftlint:disable:next line_length
    preview.subtitleLabel.text = "When his attempt to save his family inadvertently alters the future, Barry Allen becomes trapped in a reality in which General Zod has returned and there are no Super Heroes to turn to. In order to save the world that he is in and return to the future that he knows, Barry's only hope is to race for his life. But will making the ultimate sacrifice be enough to reset the universe? "
    preview.subtitleLabel.backgroundColor = .green
    preview.translatesAutoresizingMaskIntoConstraints = false
    let vc = UIViewController()
    vc.view.addSubview(preview)
    NSLayoutConstraint.activate([preview.widthAnchor.constraint(equalToConstant: 300),
                                 preview.heightAnchor.constraint(equalToConstant: 300),
                                 preview.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
                                 preview.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor)])
    
    return preview
}
#endif
