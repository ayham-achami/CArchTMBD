//  
//  PersonRenderer.swift
//  
//
//  Created by Ayham Hylam on 12.09.2023.
//

import UIKit
import CArch
import Vision
import VisionKit
import TMDBUIKit
import AlamofireImage

/// Протокол взаимодействия пользователя с модулем
protocol PersonRendererUserInteraction: AnyUserInteraction {}

/// Объект содержащий логику отображения данных
final class PersonRenderer: UIScrollView, UIRenderer {
    
    // MARK: - Renderer model
    typealias ModelType = Model
    
    struct Model: UIModel {
        
        let portraitPath: String
    }
    
    private let personBaseURL: URL = {
        .init(string: "https://image.tmdb.org/t/p/w1280")!
    }()

    // MARK: - Private properties
    private weak var interactional: PersonRendererUserInteraction?
    
    private let interaction = ImageAnalysisInteraction()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private typealias PosterEffectView = (blur: UIVisualEffectView, vibrancy: UIVisualEffectView)
    
    private let effectView: PosterEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.contentView.addSubview(vibrancyView)
        return (blurEffectView, vibrancyView)
    }()
    
    private var portraitImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        portraitImageView.addInteraction(interaction)
    }
    
    // MARK: - Public methods
    func set(content: PersonRenderer.ModelType) {
        backgroundImageView.af.setImage(withURL: personBaseURL.appending(path: content.portraitPath))
        portraitImageView.af.setImage(withURL: personBaseURL.appending(path: content.portraitPath), completion:  { [weak self] response in
            guard case let .success(image) = response.result else { return }
            self?.lookupPortrait(image)
        })
    }
    
    private func lookupPortrait(_ image: UIImage) {
        Task {
            do {
                guard ImageAnalyzer.isSupported else { return }
                let configuration = ImageAnalyzer.Configuration([.visualLookUp])
                let analyzer = ImageAnalyzer()
                let analysis = try await analyzer.analyze(image, configuration: configuration)
                interaction.analysis = analysis
                interaction.preferredInteractionTypes = .imageSubject
                let subjects = await interaction.subjects
                portraitImageView.image = try await interaction.image(for: subjects)
                    .withShadow(offset: .init(width: 20, height: 20), color: .black)
            } catch {
                print("\(#file) Error: \(error)")
            }
        }
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
        renderingPortraitImageView()
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
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func renderingBackgroundImageView() {
        insertSubview(backgroundImageView, belowSubview: contentView)
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo:  frameLayoutGuide.topAnchor),
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
    }
    
    func renderingPortraitImageView() {
        addSubview(portraitImageView)
        NSLayoutConstraint.activate([
            portraitImageView.topAnchor.constraint(equalTo:  topAnchor, constant: 100),
            portraitImageView.widthAnchor.constraint(equalToConstant: 200),
            portraitImageView.heightAnchor.constraint(equalToConstant: 300),
            portraitImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

// MARK: - Preview
extension PersonRenderer: UIRendererPreview {
    
    final class InteractionalPreview: PersonRendererUserInteraction {}
    
    static let interactional: InteractionalPreview = .init()
    
    static func preview() -> Self {
        let preview = Self.init(interactional: interactional)
        preview.moduleDidLoad()
        preview.set(content: .init(portraitPath: "/euDPyqLnuwaWMHajcU3oZ9uZezR.jpg"))
        return preview
    }
}

extension UIImage {
    
    func withShadow(blur: CGFloat = 6,
                    offset: CGSize = .zero,
                    color: UIColor = UIColor(white: 0, alpha: 0.8)) -> UIImage {

        let shadowRect = CGRect(x: offset.width - blur,
                                y: offset.height - blur,
                                width: size.width + blur * 2,
                                height: size.height + blur * 2)
        let size = CGSize(width: max(shadowRect.maxX, size.width) - min(shadowRect.minX, 0),
                          height: max(shadowRect.maxY, size.height) - min(shadowRect.minY, 0))
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        context.setShadow(offset: offset, blur: blur, color: color.cgColor )
        
        draw(in: .init(x: max(0, -shadowRect.origin.x),
                        y: max(0, -shadowRect.origin.y),
                        width: size.width,
                        height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

#Preview(String(describing: PersonRenderer.self)) {
    PersonRenderer.preview()
}
