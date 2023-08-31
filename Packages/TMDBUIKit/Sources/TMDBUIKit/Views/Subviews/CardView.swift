//
//  CardView.swift
//  TMDB

import UIKit

open class CardView: UIView {
    
    public typealias EffectView = (blur: UIVisualEffectView, vibrancy: UIVisualEffectView)
    
    open var isShadowed: Bool {
        false
    }
    
    public let effectView: EffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.contentView.addSubview(vibrancyView)
        
        return (blurEffectView, vibrancyView)
    }()
    
    public var contentView: UIView {
        effectView.vibrancy.contentView
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        rendering()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        rendering()
    }
    
    open func rendering() {
        backgroundColor = .clear
        if isShadowed {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
            layer.shadowOpacity = 0.4
            layer.shadowRadius = 5.0
            layer.cornerRadius = 18
        }
        
        NSLayoutConstraint.activate([
            effectView.vibrancy.topAnchor.constraint(equalTo: effectView.blur.topAnchor),
            effectView.vibrancy.bottomAnchor.constraint(equalTo: effectView.blur.bottomAnchor),
            effectView.vibrancy.leadingAnchor.constraint(equalTo: effectView.blur.leadingAnchor),
            effectView.vibrancy.trailingAnchor.constraint(equalTo: effectView.blur.trailingAnchor)
        ])
        
        effectView.blur.layer.cornerRadius = 18
        effectView.blur.layer.masksToBounds = true
        
        addSubview(effectView.blur)
        NSLayoutConstraint.activate([
            effectView.blur.topAnchor.constraint(equalTo: topAnchor),
            effectView.blur.bottomAnchor.constraint(equalTo: bottomAnchor),
            effectView.blur.leadingAnchor.constraint(equalTo: leadingAnchor),
            effectView.blur.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

#Preview(String(describing: CardView.self)) {
    let preview = CardView(frame: .zero)
    let vc = UIViewController()
    vc.view.addSubview(preview)
    NSLayoutConstraint.activate([preview.widthAnchor.constraint(equalToConstant: 300),
                                 preview.heightAnchor.constraint(equalToConstant: 300),
                                 preview.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
                                 preview.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor)])
    
    return preview
}
