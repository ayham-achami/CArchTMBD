//
//  MovieDetailsRenderer.swift
//

import AlamofireImage
import CArch
import CoreImage
import TMDBUIKit
import UIKit

/// Протокол взаимодействия пользователя с модулем
protocol MovieDetailsRendererUserInteraction: AnyUserInteraction {
    
    /// Вызывается при выборе актера из списка
    /// - Parameter id: Идентификатор актера
    func didRequestPersonDetails(with id: Int)
}

/// Объект содержащий логику отображения данных
final class MovieDetailsRenderer: UIScrollView, UIRenderer {
    
    // MARK: - Renderer model
    typealias ModelType = Model
    private typealias PosterEffectView = (blur: UIVisualEffectView, vibrancy: UIVisualEffectView)
    
    struct Model: UIModel {
        
        let id: Int
        let posterPath: String
        let title: TitleView.Model
        let about: AboutView.Model
        let overview: OverviewView.Model
        let credits: [CreditCell.Model]
    }
    
    // MARK: - Private properties
    private weak var interactional: MovieDetailsRendererUserInteraction?
    
    private let posterBaseURL: URL = {
        .init(string: "https://image.tmdb.org/t/p/w1280")!
    }()
    
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
        blurEffectView.alpha = 0.8
        return (blurEffectView, vibrancyView)
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor]
        gradientLayer.frame = .init(origin: .zero, size: .init(width: 2000, height: 2000))
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.2)
        return gradientLayer
    }()
    
    private lazy var titleView: TitleView = {
        let view = TitleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var overviewView: OverviewView = {
        let view = OverviewView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var aboutView: AboutView = {
        let view = AboutView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var creditsView: CreditsView = {
        let view = CreditsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var titleViewTopConstraint: NSLayoutConstraint?
    
    // MARK: - Inits
    init(interactional: MovieDetailsRendererUserInteraction) {
        super.init(frame: .zero)
        self.interactional = interactional
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    func moduleDidLoad() {
        creditsView.delegate = self
        rendering()
    }
    
    func moduleLayoutSubviews() {
        titleViewTopConstraint?.constant = center.y
    }
    
    // MARK: - Public methods
    func set(content: MovieDetailsRenderer.ModelType) {
        backgroundImageView.af.setImage(withURL: posterBaseURL.appending(path: content.posterPath))
        titleView.set(content: content.title)
        overviewView.set(content: content.overview)
        aboutView.set(content: content.about)
        creditsView.set(content: content.credits)
    }
}

// MARK: - Renderer + IBAction
private extension MovieDetailsRenderer {}

// MARK: - Private methods
private extension MovieDetailsRenderer {
    
    func rendering() {
        backgroundColor = Colors.primaryBack.color
        renderingContentView()
        renderingBackgroundImageView()
        renderingEffectView()
        renderingTitleView()
        renderingOverviewView()
        renderingAboutView()
        renderingCreditsView()
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
            backgroundImageView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 200)
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
            effectView.blur.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            effectView.blur.bottomAnchor.constraint(equalTo: frameLayoutGuide.bottomAnchor),
            effectView.blur.leadingAnchor.constraint(equalTo: frameLayoutGuide.leadingAnchor),
            effectView.blur.trailingAnchor.constraint(equalTo: frameLayoutGuide.trailingAnchor)
        ])
        
        effectView.blur.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        effectView.blur.layer.mask = gradientLayer
    }
    
    func renderingTitleView() {
        contentView.addSubview(titleView)
        let topConstraint = titleView.topAnchor.constraint(greaterThanOrEqualTo: contentView.safeAreaLayoutGuide.topAnchor,
                                                           constant: 300)
        NSLayoutConstraint.activate([
            topConstraint,
            titleView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            titleView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            titleView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -8)
        ])
        titleViewTopConstraint = topConstraint
    }
    
    func renderingOverviewView() {
        contentView.addSubview(overviewView)
        NSLayoutConstraint.activate([
            overviewView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            overviewView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 16),
            overviewView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            overviewView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -8)
        ])
    }
    
    func renderingAboutView() {
        contentView.addSubview(aboutView)
        NSLayoutConstraint.activate([
            aboutView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            aboutView.topAnchor.constraint(equalTo: overviewView.bottomAnchor, constant: 16),
            aboutView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            aboutView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -9)
        ])
    }
    
    func renderingCreditsView() {
        creditsView.contentInset = .init(top: 0, left: 8, bottom: 0, right: 8)
        contentView.addSubview(creditsView)
        NSLayoutConstraint.activate([
            creditsView.heightAnchor.constraint(equalToConstant: 250),
            creditsView.topAnchor.constraint(equalTo: aboutView.bottomAnchor, constant: 16),
            creditsView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            creditsView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            creditsView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}

#if DEBUG
// MARK: - Preview
extension MovieDetailsRenderer: UIRendererPreview {
    
    static func preview() -> Self {
        let preview = Self.init(interactional: InteractionalPreview.interactional)
        preview.moduleDidLoad()
        let title = TitleView.Model(rating: 0.68,
                                    title: "Oppenheimer ",
                                    genres: "Drama, History",
                                    tagline: "The world forever changes.")
        let abut = AboutView.Model(date: "30.07.23",
                                   status: "Released",
                                   budget: "$100,000,000.00",
                                   revenue: "$400,388,430.00",
                                   runtime: "3h 1m",
                                   language: "English",
                                   countries: "US, GB")
        let overview = OverviewView.Model(overview: """
The story of J. Robert Oppenheimer’s role in the development of the atomic bomb during World War II.
""")
        let credits = (1...10).map { id in
            CreditCell.Model(id: id,
                             name: "Cillian Murphy",
                             character: "J. Robert Oppenheimer",
                             posterPath: "/llkbyWKwpfowZ6C8peBjIV9jj99.jpg")
        }
        preview.set(content: .init(id: 0,
                                   posterPath: "/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg",
                                   title: title,
                                   about: abut,
                                   overview: overview,
                                   credits: credits))
        preview.moduleLayoutSubviews()
        return preview
    }
    
    final class InteractionalPreview: MovieDetailsRendererUserInteraction {
     
        static let interactional: InteractionalPreview = .init()
        
        func didRequestPersonDetails(with id: Int) {
            print(id)
        }
    }
}

extension MovieDetailsRenderer: CreditsViewDelegate {
    
    func creditsView(_ creditsView: CreditsView, didSelectedPersone id: Int) {
        interactional?.didRequestPersonDetails(with: id)
    }
}

#Preview(String(describing: MovieDetailsRenderer.self)) {
    let vc = UIViewController()
    let preview = MovieDetailsRenderer.preview()
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
