//
//  PersonalInfoView.swift
//

import CArch
import TMDBUIKit
import UIKit

final class PersonalInfoView: CardView {
    
    struct Model: UIModel {
        
        let knownFor: String
        let gender: String
        let birthday: String
        let placeOfBirth: String
    }
    
    private let knownForView: VerticalSubtitleView = {
        let view = VerticalSubtitleView()
        view.titleLabel.text = "Known For"
        view.titleLabel.font = UIFont.Bold.body1
        view.subtitleLabel.font = UIFont.Regular.body2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let genderView: VerticalSubtitleView = {
        let view = VerticalSubtitleView()
        view.titleLabel.text = "Gender"
        view.titleLabel.font = UIFont.Bold.body1
        view.subtitleLabel.font = UIFont.Regular.body2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let birthdayView: VerticalSubtitleView = {
        let view = VerticalSubtitleView()
        view.titleLabel.text = "Birthday"
        view.titleLabel.font = UIFont.Bold.body1
        view.subtitleLabel.font = UIFont.Regular.body2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let placeOfBirthView: VerticalSubtitleView = {
        let view = VerticalSubtitleView()
        view.titleLabel.text = "Place of Birth"
        view.titleLabel.font = UIFont.Bold.body1
        view.subtitleLabel.font = UIFont.Regular.body2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func set(content: Model) {
        knownForView.subtitleLabel.text = content.knownFor
        genderView.subtitleLabel.text = content.gender
        birthdayView.subtitleLabel.text = content.birthday
        placeOfBirthView.subtitleLabel.text = content.placeOfBirth
    }
    
    override func rendering() {
        super.rendering()
        contentView.addSubview(knownForView)
        NSLayoutConstraint.activate([
            knownForView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            knownForView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            knownForView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        contentView.addSubview(genderView)
        NSLayoutConstraint.activate([
            genderView.topAnchor.constraint(equalTo: knownForView.bottomAnchor),
            genderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            genderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        contentView.addSubview(birthdayView)
        NSLayoutConstraint.activate([
            birthdayView.topAnchor.constraint(equalTo: genderView.bottomAnchor),
            birthdayView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            birthdayView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        contentView.addSubview(placeOfBirthView)
        let bottomConstraint = placeOfBirthView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        bottomConstraint.priority = .defaultLow
        NSLayoutConstraint.activate([
            bottomConstraint,
            placeOfBirthView.topAnchor.constraint(equalTo: birthdayView.bottomAnchor),
            placeOfBirthView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            placeOfBirthView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}

#if DEBUG
#Preview(String(describing: CardView.self)) {
    let preview = PersonalInfoView(frame: .zero)
    preview.set(content: .init(knownFor: "Acting",
                               gender: "Female",
                               birthday: "1990-07-02 (33 years old)",
                               placeOfBirth: "Dalby, Queensland, Australia"))
    preview.translatesAutoresizingMaskIntoConstraints = false
    let vc = UIViewController()
    vc.view.addSubview(preview)
    NSLayoutConstraint.activate([preview.widthAnchor.constraint(equalToConstant: 300),
                                 preview.heightAnchor.constraint(greaterThanOrEqualToConstant: 300),
                                 preview.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
                                 preview.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor)])
    return vc
}
#endif
