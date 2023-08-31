//
//  RatingView.swift

import UIKit

public final class RatingView: UIView {
    
    public var lineWidth: CGFloat = 10 {
        didSet {
            ringWidth = lineWidth
            grooveWidth = lineWidth
        }
    }
    
    public var ringWidth: CGFloat = 10 {
        didSet {
            ringLayer.lineWidth = ringWidth
        }
    }

    public var grooveWidth: CGFloat = 10 {
        didSet {
            grooveLayer.lineWidth = grooveWidth
        }
    }

    public var startColor: UIColor = .systemPink {
        didSet {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        }
    }
    
    public var endColor: UIColor = .systemRed {
        didSet {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        }
    }
    
    public var grooveColor: UIColor = UIColor.systemGray.withAlphaComponent(0.2) {
        didSet {
            grooveLayer.strokeColor = grooveColor.cgColor
        }
    }
    
    public var startAngle: CGFloat = -.pi / 2 {
        didSet {
            ringLayer.path = ringPath()
        }
    }

    public var endAngle: CGFloat = 1.5 * .pi {
        didSet {
            ringLayer.path = ringPath()
        }
    }
    
    public var startGradientPoint: CGPoint = .init(x: 0.5, y: 0) {
        didSet {
            gradientLayer.startPoint = startGradientPoint
        }
    }
    
    public var endGradientPoint: CGPoint = .init(x: 0.5, y: 1) {
        didSet {
            gradientLayer.endPoint = endGradientPoint
        }
    }

    public var ringRadius: CGFloat {
        var radius = min(bounds.height, bounds.width) / 2 - ringWidth / 2
        if ringWidth < grooveWidth {
            radius -= (grooveWidth - ringWidth) / 2
        }
        return radius
    }
    
    public var grooveRadius: CGFloat {
        var radius = min(bounds.height, bounds.width) / 2 - grooveWidth / 2
        if grooveWidth < ringWidth {
            radius -= (ringWidth - grooveWidth) / 2
        }
        return radius
    }
    
    public var duration: TimeInterval = 2.0
    public var timingFunction: CAMediaTimingFunction = .init(controlPoints: 0.19, 1, 0.22, 1)
    public private(set) var progress: CGFloat = 0

    private let ringLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineCap = .round
        layer.fillColor = nil
        layer.strokeStart = 0
        return layer
    }()
    
    private let grooveLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineCap = .round
        layer.fillColor = nil
        layer.strokeStart = 0
        layer.strokeEnd = 1
        return layer
    }()
    
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let gradientLayer = CAGradientLayer()

    // MARK: Life Cycle
    public init() {
        super.init(frame: .zero)
        rendering()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        rendering()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        rendering()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        configureRing()
        styleRingLayer()
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        styleRingLayer()
    }

    public func setRating(text value: Float) {
        titleLabel.text = String(format: "%.2f", value)
    }
    
    public func setRating(_ value: Float, animated: Bool, completion: (() -> Void)? = nil) {
        layoutIfNeeded()
        let value = CGFloat(min(value, 1.0))
        let oldValue = ringLayer.presentation()?.strokeEnd ?? progress
        progress = value
        ringLayer.strokeEnd = progress
        guard
            animated
        else {
            layer.removeAllAnimations()
            ringLayer.removeAllAnimations()
            gradientLayer.removeAllAnimations()
            completion?()
            return
        }
        
        CATransaction.begin()
        let path = #keyPath(CAShapeLayer.strokeEnd)
        let fill = CABasicAnimation(keyPath: path)
        fill.fromValue = oldValue
        fill.toValue = value
        fill.duration = duration
        fill.timingFunction = timingFunction
        CATransaction.setCompletionBlock(completion)
        ringLayer.add(fill, forKey: "fill")
        CATransaction.commit()
    }

    
    private func rendering() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        preservesSuperviewLayoutMargins = true
        layer.addSublayer(grooveLayer)
        layer.addSublayer(gradientLayer)
        styleRingLayer()
    }

    private func styleRingLayer() {
        grooveLayer.strokeColor = grooveColor.cgColor
        grooveLayer.lineWidth = grooveWidth
        
        ringLayer.lineWidth = ringWidth
        ringLayer.strokeColor = UIColor.black.cgColor
        ringLayer.strokeEnd = min(progress, 1.0)
        
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1)
        
        gradientLayer.shadowColor = startColor.cgColor
        gradientLayer.shadowOffset = .zero
    }

    private func configureRing() {
        let ringPath = self.ringPath()
        let groovePath = self.groovePath()
        grooveLayer.frame = bounds
        grooveLayer.path = groovePath
        
        ringLayer.frame = bounds
        ringLayer.path = ringPath
        
        gradientLayer.frame = bounds
        gradientLayer.mask = ringLayer
    }

    private func ringPath() -> CGPath {
        let center = CGPoint(x: bounds.origin.x + frame.width / 2.0, y: bounds.origin.y + frame.height / 2.0)
        let circlePath = UIBezierPath(arcCenter: center, radius: ringRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        return circlePath.cgPath
    }
    
    private func groovePath() -> CGPath {
        let center = CGPoint(x: bounds.origin.x + frame.width / 2.0, y: bounds.origin.y + frame.height / 2.0)
        let circlePath = UIBezierPath(arcCenter: center, radius: grooveRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        return circlePath.cgPath
    }
}

#Preview(String(describing: RatingView.self)) {
    let preview = RatingView(frame: .zero)
    preview.backgroundColor = .systemFill
    preview.layer.cornerRadius = 50
    preview.grooveColor = .systemGray
    preview.endColor = .red
    preview.startColor = .green
    preview.lineWidth = 5
    preview.ringWidth = 5
    preview.grooveWidth = 5
    preview.titleLabel.text = "80 %"
    preview.setRating(0.9, animated: true)
    let vc = UIViewController()
    vc.view.addSubview(preview)
    NSLayoutConstraint.activate([preview.widthAnchor.constraint(equalToConstant: 100),
                                 preview.heightAnchor.constraint(equalToConstant: 100),
                                 preview.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
                                 preview.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor)])
    return preview
}
