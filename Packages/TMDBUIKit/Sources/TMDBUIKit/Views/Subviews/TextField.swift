//
//  TextField.swift
//  TMDB

import UIKit

public final class TextField: UITextField {
    
    private struct Constants {
        
        let height: CGFloat = 48
        let cornerRadius: CGFloat = 8
        let leftViewPadding: CGFloat = 16
        let rightViewPadding: CGFloat = 12
        let rightViewSize = CGSize(width: 32, height: 32)
        let titleOffset = UIOffset(horizontal: .zero, vertical: -6)
        let hintOffset = UIOffset(horizontal: .zero, vertical: 6)
        let textInputPadding = UIEdgeInsets(top: .zero, left: 16, bottom: .zero, right: 16)
    }
    
    public enum HintState {
        
        case error
        case success
        case plainText
    }
    
    public enum RightViewType: String {
        
        case clear
        case reveal
    }
    
    // MARK: - Public properties
    public var title: String? {
        didSet {
            titleLayer.string = title
            layoutTitle()
        }
    }
    
    public var additionalTitle: String? {
        didSet {
            additionalTitleLayer.string = additionalTitle
            layoutAdditionalTitle()
        }
    }
    
    public var hint: String? {
        didSet {
            hintLayer.string = hint
            invalidateIntrinsicContentSize()
            layoutHint()
        }
    }
    
    public var rightViewType: RightViewType = .clear {
        didSet {
            setupRightView()
        }
    }
    
    private(set) var hintState: HintState = .plainText {
        didSet {
            setupHintColors()
        }
    }
    
    public override var text: String? {
        didSet {
            if hintState == .error {
                hideError()
            }
        }
    }
    
    public override var placeholder: String? {
        didSet {
            setupPlaceholder()
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.height = constants.height + bottomHeight
        return size
    }
    
    public override var isSecureTextEntry: Bool {
        didSet {
            guard isSecureTextEntry else { return }
            rightViewType = .reveal
        }
    }
    
    // MARK: - Private properties
    private let constants = Constants()
    private let backgroundLayer = CALayer()
    private var originalHint: String?
    
    private var hintHeight: CGFloat {
        textRect(for: hint, boundingWidth: bounds.width, font: titleFont).height
    }
    
    private var bottomHeight: CGFloat {
        let hintHeight = hintHeight
        return hintHeight != .zero ? hintHeight + constants.hintOffset.vertical : .zero
    }
    private lazy var titleFont = UIFont.Regular.footnote
    
    private lazy var titleLayer: CATextLayer = {
        let layer = CATextLayer()
        layer.contentsScale = UIScreen.main.scale
        layer.anchorPoint = .zero
        layer.isWrapped = true
        layer.truncationMode = .end
        layer.font = titleFont
        layer.fontSize = titleFont.pointSize
        layer.foregroundColor = Colors.secondaryText.color.cgColor
        return layer
    }()
    
    private lazy var additionalTitleLayer: CATextLayer = {
        let layer = CATextLayer()
        layer.contentsScale = UIScreen.main.scale
        layer.anchorPoint = .zero
        layer.isWrapped = true
        layer.truncationMode = .end
        layer.font = titleFont
        layer.fontSize = titleFont.pointSize
        layer.foregroundColor = Colors.primaryText.color.cgColor
        return layer
    }()
    
    private lazy var hintLayer: CATextLayer = {
        let layer = CATextLayer()
        layer.contentsScale = UIScreen.main.scale
        layer.anchorPoint = .zero
        layer.isWrapped = true
        layer.truncationMode = .end
        layer.font = titleFont
        layer.fontSize = titleFont.pointSize
        return layer
    }()
    
    private lazy var clearButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: constants.rightViewSize))
        button.setImage(Images.cross.image, for: .normal)
        button.tintColor = Colors.secondaryText.color
        button.addTarget(self, action: #selector(didTapClear), for: .touchUpInside)
        return button
    }()
    
    private lazy var revealButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: constants.rightViewSize))
        button.setImage(Images.eyeClose.image, for: .normal)
        button.setImage(Images.eyeOpen.image, for: .selected)
        button.tintColor = Colors.secondaryText.color
        button.addTarget(self, action: #selector(didTapReveal), for: .touchUpInside)
        button.isSelected = !isSecureTextEntry
        return button
    }()
    
    // MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layoutBackground()
        layoutTitle()
        layoutAdditionalTitle()
        layoutHint()
        layoutRightViewButton()
    }
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.textRect(forBounds: bounds)
        rect.size.height -= bottomHeight
        return rect.inset(by: constants.textInputPadding)
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.editingRect(forBounds: bounds)
        rect.size.height -= bottomHeight
        return rect.inset(by: constants.textInputPadding)
    }
    
    public override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin = CGPoint(x: rect.origin.x + constants.leftViewPadding,
                              y: constants.height / 2 - rect.height / 2)
        return rect
    }
    
    public override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin = .init(x: rect.origin.x - constants.rightViewPadding,
                            y: (constants.height / 2) - (rect.height / 2))
        return rect
    }
}

// MARK: - TextField + Public
public extension TextField {
    
    func showError(text: String? = nil) {
        if hintState == .error {
            UIView.performWithoutAnimation { hideError() }
        }
        if let errorText = text {
            originalHint = hint ?? ""
            hint = errorText
        }
        hintState = .error
        backgroundLayer.borderWidth = 1
        backgroundLayer.borderColor = hintLayer.foregroundColor
        shakeAnimation()
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
    
    func hideError() {
        hint = originalHint ?? ""
        hintState = .plainText
        backgroundLayer.borderWidth = 0
        backgroundLayer.borderColor = nil
    }
    
    func showSuccess(text: String? = nil) {
        if hintState == .success {
            UIView.performWithoutAnimation { hideError() }
        }
        if let successText = text {
            originalHint = hint ?? ""
            hint = successText
        }
        hintState = .success
        backgroundLayer.borderWidth = 1
        backgroundLayer.borderColor = hintLayer.foregroundColor
        shakeAnimation()
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
    
    func hideSuccess() {
        hint = originalHint ?? ""
        hintState = .plainText
        backgroundLayer.borderWidth = 0
        backgroundLayer.borderColor = nil
    }
}

// MARK: - TextField + Actions
private extension TextField {
    
    @objc func didBeginEditing() {
        setupBackgroundColors()
    }
    
    @objc func didEndEditing() {
        setupBackgroundColors()
    }
    
    @objc func didTapClear() {
        text = nil
        sendActions(for: .editingChanged)
    }
    
    @objc func didTapReveal() {
        isSecureTextEntry.toggle()
        revealButton.isSelected = !isSecureTextEntry
    }
}

// MARK: - TextField + Private
private extension TextField {
    
    // MARK: - Layout
    func layoutBackground() {
        backgroundLayer.frame = CGRect(x: bounds.minX,
                                       y: bounds.minY,
                                       width: bounds.width,
                                       height: bounds.height - bottomHeight)
    }
    
    func layoutTitle() {
        let textRect = textRect(for: title,
                                boundingWidth: textFieldRect().width,
                                font: titleFont)
        titleLayer.frame = CGRect(x: bounds.minX + constants.titleOffset.horizontal,
                                  y: -textRect.height + constants.titleOffset.vertical,
                                  width: textRect.width,
                                  height: textRect.height)
    }
    
    func layoutAdditionalTitle() {
        let textRect = textRect(for: additionalTitle,
                                boundingWidth: textFieldRect().width,
                                font: titleFont)
        additionalTitleLayer.frame = CGRect(x: bounds.width - textRect.width,
                                            y: -textRect.height + constants.titleOffset.vertical,
                                            width: textRect.width,
                                            height: textRect.height)
    }
    
    func layoutHint() {
        let textRect = textRect(for: hint,
                                boundingWidth: textFieldRect().width,
                                font: titleFont)
        let originFrame = CGRect(x: bounds.minX,
                                 y: bounds.height - bottomHeight,
                                 width: bounds.width,
                                 height: textRect.height)
        hintLayer.frame = originFrame.offsetBy(dx: constants.hintOffset.horizontal, dy: constants.hintOffset.vertical)
    }
    
    func layoutRightViewButton() {
        switch rightViewType {
        case .clear:
            layoutClearButton()
        case .reveal:
            layoutRevealButton()
        }
    }
    
    func layoutClearButton() {
        clearButton.frame = rightViewRect(forBounds: bounds)
    }
    
    func layoutRevealButton() {
        revealButton.frame = rightViewRect(forBounds: bounds)
    }
    
    func textFieldRect() -> CGRect {
        super.textRect(forBounds: bounds)
    }
    
    func textRect(for string: String?, boundingWidth: CGFloat, font: UIFont) -> CGRect {
        guard let string = string, !string.isEmpty else { return .zero }
        guard boundingWidth != .zero else { return .zero }
        let constraintRect = CGSize(width: boundingWidth, height: .greatestFiniteMagnitude)
        let stringOptions: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]
        let boundingBox = string.boundingRect(with: constraintRect,
                                              options: stringOptions,
                                              attributes: [NSAttributedString.Key.font: font],
                                              context: nil)
        return boundingBox
    }
    
    // MARK: - Setup
    func setup() {
        borderStyle = .none
        layer.borderWidth = 0
        setContentCompressionResistancePriority(.required, for: .vertical)
        setContentHuggingPriority(.required, for: .vertical)
        addTarget(self, action: #selector(didBeginEditing), for: .editingDidBegin)
        addTarget(self, action: #selector(didEndEditing), for: .editingDidEnd)
        font = .Regular.body1
        returnKeyType = .done
        setupPlaceholder()
        setupInputColors()
        setupBackgroundLayer()
        setupTitle()
        setupAdditionalTitle()
        setupHint()
        if isSecureTextEntry {
            rightViewType = .reveal
        } else {
            setupRightView()
        }
    }
    
    func setupPlaceholder() {
//        attributedPlaceholder = if let placeholder {
//            .init(string: placeholder, attributes: [.foregroundColor: Colors.tertiaryText.color])
//        } else {
//            .init()
//        }
    }
    
    func setupInputColors() {
        textColor = Colors.primaryText.color
        tintColor = Colors.primaryText.color
    }
    
    func setupBackgroundLayer() {
        backgroundLayer.cornerRadius = constants.cornerRadius
        backgroundLayer.masksToBounds = true
        setupBackgroundColors()
        layer.addSublayer(backgroundLayer)
    }
    
    func setupBackgroundColors() {
        if isFirstResponder {
            backgroundLayer.backgroundColor = Colors.tertiaryBack.color.cgColor
        } else {
            backgroundLayer.backgroundColor = Colors.secondaryBack.color.cgColor
        }
    }
    
    func setupTitle() {
        titleLayer.string = title
        layer.addSublayer(titleLayer)
    }
    
    func setupAdditionalTitle() {
        additionalTitleLayer.string = additionalTitle
        layer.addSublayer(additionalTitleLayer)
    }
    
    func setupHint() {
        hintLayer.string = hint
        setupHintColors()
        layer.addSublayer(hintLayer)
    }
    
    func setupHintColors() {
        switch hintState {
        case .plainText:
            hintLayer.foregroundColor = Colors.secondaryText.color.cgColor
        case .error:
            hintLayer.foregroundColor = Colors.danger.color.cgColor
        case .success:
            hintLayer.foregroundColor = Colors.success.color.cgColor
        }
    }
    
    func setupRightView() {
        switch rightViewType {
        case .clear:
            setupClearButton()
        case .reveal:
            setupRevealButton()
        }
    }
    
    func setupClearButton() {
        rightView = clearButton
        rightViewMode = .whileEditing
    }
    
    func setupRevealButton() {
        rightView = revealButton
        rightViewMode = .always
    }
}

// MARK: - TextField + Animation
private extension TextField {
    
    func shakeAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.5
        animation.values = [-12.0, 12.0, -12.0, 12.0, -6.0, 6.0, -3.0, 3.0, 0.0]
        layer.add(animation, forKey: "shake")
    }
}

// MARK: - Preview
#Preview(String(describing: TextField.self), traits: .fixedLayout(width: 300, height: 300)) {
    let preview = TextField(frame: .zero)
    preview.title = "Title"
//    preview.text = "abc@abc.abc"
    preview.placeholder = "placeholder"
    preview.additionalTitle = "Additional title"
    preview.hint = "Hint"
    preview.rightViewType = .reveal
    //preview.showError(text: "Error")
    let vc = UIViewController()
    vc.view.addSubview(preview)
    NSLayoutConstraint.activate([preview.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
                                 preview.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor),
                                 preview.widthAnchor.constraint(equalToConstant: 300),
                                 preview.heightAnchor.constraint(equalToConstant: 50)])
    
    return preview
}

