//
//  PersonRenderer.swift
//

import AlamofireImage
import CArch
import TMDBUIKit
import UIKit

/// Протокол взаимодействия пользователя с модулем
protocol PersonRendererUserInteraction: AnyUserInteraction {}

/// Объект содержащий логику отображения данных
final class PersonRenderer: UIScrollView, UIRenderer {
    
    // MARK: - Renderer model
    typealias ModelType = Model
    private typealias PosterEffectView = (blur: UIVisualEffectView, vibrancy: UIVisualEffectView)
    
    struct Model: UIModel {
        
        let biography: BiographyView.Model
        let portraits: ProfileImagesView.Model
        let personality: PersonalityView.Model
        let personalInfo: PersonalInfoView.Model
    }
    
    private let personBaseURL: URL = {
        .init(string: "https://www.themoviedb.org/t/p/original")!
    }()
    
    // MARK: - Private properties
    private weak var interactional: PersonRendererUserInteraction?
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var effectView: PosterEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.contentView.addSubview(vibrancyView)
        return (blurEffectView, vibrancyView)
    }()
    
    private lazy var profileImagesView: ProfileImagesView = {
        let view = ProfileImagesView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var personalityView: PersonalityView = {
        let view = PersonalityView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var personalInfoView: PersonalInfoView = {
        let view = PersonalInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var biographyView: BiographyView = {
        let view = BiographyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Inits
    init(interactional: PersonRendererUserInteraction) {
        super.init(frame: .zero)
        self.interactional = interactional
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    func moduleDidLoad() {
        rendering()
    }
    
    // MARK: - Public methods
    func set(content: PersonRenderer.ModelType) {
        if let portrait = content.portraits.randomElement() {
            backgroundImageView.setImage(with: personBaseURL, path: portrait.path)
        }
        profileImagesView.set(content: content.portraits)
        biographyView.set(content: content.biography)
        personalityView.set(content: content.personality)
        personalInfoView.set(content: content.personalInfo)
    }
}

// MARK: - Renderer + IBAction
private extension PersonRenderer {}

// MARK: - Private methods
private extension PersonRenderer {
    
    func rendering() {
        backgroundColor = Colors.primaryBack.color
        renderingContentView()
        renderingBackgroundImageView()
        renderingEffectView()
        reneringProfileImagesView()
        renderingPersonalityView()
        renderingPersonalInfoView()
        renderingBiographyView()
    }
    
    func renderingContentView() {
        addSubview(contentView)
        let heightConstraint = contentView.heightAnchor.constraint(equalTo: heightAnchor)
        heightConstraint.priority = .defaultLow
        NSLayoutConstraint.activate([
            heightConstraint,
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func renderingBackgroundImageView() {
        insertSubview(backgroundImageView, belowSubview: contentView)
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: frameLayoutGuide.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: frameLayoutGuide.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: frameLayoutGuide.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: frameLayoutGuide.trailingAnchor)
        ])
    }
    
    func renderingEffectView() {
        NSLayoutConstraint.activate([
            effectView.vibrancy.topAnchor.constraint(equalTo: effectView.blur.topAnchor),
            effectView.vibrancy.bottomAnchor.constraint(equalTo: effectView.blur.bottomAnchor),
            effectView.vibrancy.leadingAnchor.constraint(equalTo: effectView.blur.leadingAnchor),
            effectView.vibrancy.trailingAnchor.constraint(equalTo: effectView.blur.trailingAnchor)
        ])
        
        contentView.addSubview(effectView.blur)
        NSLayoutConstraint.activate([
            effectView.blur.topAnchor.constraint(equalTo: frameLayoutGuide.topAnchor),
            effectView.blur.bottomAnchor.constraint(equalTo: frameLayoutGuide.bottomAnchor),
            effectView.blur.leadingAnchor.constraint(equalTo: frameLayoutGuide.leadingAnchor),
            effectView.blur.trailingAnchor.constraint(equalTo: frameLayoutGuide.trailingAnchor)
        ])
        
        effectView.blur.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func reneringProfileImagesView() {
        contentView.addSubview(profileImagesView)
        NSLayoutConstraint.activate([
            profileImagesView.heightAnchor.constraint(equalToConstant: 500),
            profileImagesView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            profileImagesView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            profileImagesView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
    }
    
    func renderingPersonalityView() {
        contentView.addSubview(personalityView)
        NSLayoutConstraint.activate([
            personalityView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            personalityView.topAnchor.constraint(equalTo: profileImagesView.bottomAnchor, constant: 16),
            personalityView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            personalityView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -8)
        ])
    }
    
    func renderingPersonalInfoView() {
        contentView.addSubview(personalInfoView)
        NSLayoutConstraint.activate([
            personalInfoView.heightAnchor.constraint(greaterThanOrEqualToConstant: 350),
            personalInfoView.topAnchor.constraint(equalTo: personalityView.safeAreaLayoutGuide.bottomAnchor, constant: 16),
            personalInfoView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            personalInfoView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -8)
        ])
    }
    
    func renderingBiographyView() {
        contentView.addSubview(biographyView)
        NSLayoutConstraint.activate([
            biographyView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            biographyView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            biographyView.topAnchor.constraint(equalTo: personalInfoView.safeAreaLayoutGuide.bottomAnchor, constant: 16),
            biographyView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            biographyView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -8)
        ])
    }
}

#if DEBUG
// MARK: - Preview
extension PersonRenderer: UIRendererPreview {

    static func preview() -> Self {
        let preview = Self.init(interactional: InteractionalPreview.interactional)
        preview.moduleDidLoad()
        preview.set(content: .init(biography: .init(knownAs: "Марго Роббі Марго Робби มาร์โก ร็อบบี 瑪歌·羅比 마고 로비",
                                                    // swiftlint:disable:next line_length
                                                    biography: "Margot Elise Robbie (born July 2, 1990) is an Australian actress and producer. Known for her work in both blockbuster and independent films, she has received several accolades, including nominations for two Academy Awards, four Golden Globe Awards, and five British Academy Film Awards. Time magazine named her one of the 100 most influential people in the world in 2017 and she was ranked as one of the world's highest-paid actresses by Forbes in 2019."),
                                   portraits: (0...10).map { _ in .init(path: "/euDPyqLnuwaWMHajcU3oZ9uZezR.jpg")},
                                   personality: .init(name: "Margot Robbie", rating: 0.7),
                                   personalInfo: .init(knownFor: "Acting",
                                                       gender: "Female",
                                                       birthday: "1990-07-02 (33 years old)",
                                                       placeOfBirth: "Dalby, Queensland, Australia")))
        return preview
    }
    
    final class InteractionalPreview: PersonRendererUserInteraction {
        
        static let interactional: InteractionalPreview = .init()
    }
}

#Preview(String(describing: PersonRenderer.self)) {
    let vc = UIViewController()
    let preview = PersonRenderer.preview()
    preview.translatesAutoresizingMaskIntoConstraints = false
    vc.view.addSubview(preview)
    NSLayoutConstraint.activate([
        preview.topAnchor.constraint(equalTo: vc.view.topAnchor),
        preview.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
        preview.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
        preview.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor)
    ])
    return vc
}
#endif
