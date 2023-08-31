//
//  AboutView.swift

import UIKit
import CArch
import TMDBUIKit

final class AboutView: CardView {
    
    struct Model: UIModel {
        
        let date: String
        let status: String
        let budget: String
        let revenue: String
        let runtime: String
        let language: String
        let countries: String
    }
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countriesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let runtimeView: HorizontalSubtitleView = {
        let view = HorizontalSubtitleView()
        view.titleLabel.text = "Runtime:"
        view.titleLabel.font = UIFont.Bold.body2
        view.subtitleLabel.font = UIFont.Regular.body2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let statusView: HorizontalSubtitleView = {
        let view = HorizontalSubtitleView()
        view.titleLabel.text = "Status:"
        view.titleLabel.font = UIFont.Bold.body2
        view.subtitleLabel.font = UIFont.Regular.body2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let languageView: HorizontalSubtitleView = {
        let view = HorizontalSubtitleView()
        view.titleLabel.text = "Original Language:"
        view.titleLabel.font = UIFont.Bold.body2
        view.subtitleLabel.font = UIFont.Regular.body2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let budgetView: HorizontalSubtitleView = {
        let view = HorizontalSubtitleView()
        view.titleLabel.text = "Budget:"
        view.titleLabel.font = UIFont.Bold.body2
        view.subtitleLabel.font = UIFont.Regular.body2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let revenueView: HorizontalSubtitleView = {
        let view = HorizontalSubtitleView()
        view.titleLabel.text = "Revenue:"
        view.titleLabel.font = UIFont.Bold.body2
        view.subtitleLabel.font = UIFont.Regular.body2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func set(content: Model) {
        dateLabel.text = content.date
        countriesLabel.text = content.countries
        runtimeView.subtitleLabel.text = content.runtime
        statusView.subtitleLabel.text = content.status
        languageView.subtitleLabel.text = content.language
        budgetView.subtitleLabel.text = content.budget
        revenueView.subtitleLabel.text = content.revenue
    }
    
    override func rendering() {
        super.rendering()
        
        contentView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        ])
        
        contentView.addSubview(countriesLabel)
        NSLayoutConstraint.activate([
            countriesLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            countriesLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            countriesLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 16),
            countriesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
        
        dateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        dateLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        countriesLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        countriesLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        contentView.addSubview(runtimeView)
        NSLayoutConstraint.activate([
            runtimeView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            runtimeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            runtimeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        contentView.addSubview(statusView)
        NSLayoutConstraint.activate([
            statusView.topAnchor.constraint(equalTo: runtimeView.bottomAnchor, constant: 8),
            statusView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            statusView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
        
        contentView.addSubview(languageView)
        NSLayoutConstraint.activate([
            languageView.topAnchor.constraint(equalTo: statusView.bottomAnchor, constant: 8),
            languageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            languageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        contentView.addSubview(budgetView)
        NSLayoutConstraint.activate([
            budgetView.topAnchor.constraint(equalTo: languageView.bottomAnchor, constant: 8),
            budgetView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            budgetView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
        
        contentView.addSubview(revenueView)
        NSLayoutConstraint.activate([
            revenueView.topAnchor.constraint(equalTo: budgetView.bottomAnchor, constant: 8),
            revenueView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            revenueView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            revenueView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
}

#Preview(String(describing: CardView.self)) {
    let preview = AboutView(frame: .zero)
    preview.set(content: .init(date: "30.07.23",
                               status: "Released",
                               budget: "$100,000,000.00",
                               revenue: "$400,388,430.00",
                               runtime: "3h 1m",
                               language: "English",
                               countries: "US, GB"))
    preview.translatesAutoresizingMaskIntoConstraints = false
    let vc = UIViewController()
    vc.view.addSubview(preview)
    NSLayoutConstraint.activate([preview.widthAnchor.constraint(equalToConstant: 300),
                                 preview.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
                                 preview.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor)])
    
    return vc
}
