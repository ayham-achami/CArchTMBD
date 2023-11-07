//
//  KeyboardNotificationConstraint.swift
//

#if canImport(UIKit)
import UIKit

public final class KeyboardNotificationConstraint: NSLayoutConstraint {
    
    public var bottomOffset: CGFloat = 0
    public var bottomBarHeight: CGFloat = 0
    public var interactiveKeyboardFrameChange: Bool = true
    
    public override var isActive: Bool {
        didSet {
            if isActive {
                setupNotifications()
            } else {
                // swiftlint:disable:next superfluous_disable_command notification_center_detachment
                NotificationCenter.default.removeObserver(self)
            }
        }
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChangeFrame(_:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }
    
    private func layout(animate: Bool = true, duration: TimeInterval = 0.2, options: UIView.AnimationOptions = []) {
        if animate {
            UIView.animate(withDuration: duration, delay: .zero, options: options, animations: {
                self.firstItem?.layoutIfNeeded()
            })
        } else {
            firstItem?.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
           let view = firstItem as? UIView {
            let convertedRect = view.convert(keyboardSize, to: view.window)
            constant = max(view.frame.height - convertedRect.minY, 0) - bottomOffset + bottomBarHeight
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.2
            let row = UInt(notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int ?? 0)
            layout(duration: duration, options: UIView.AnimationOptions(rawValue: row))
        }
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: NSNotification) {
        guard interactiveKeyboardFrameChange else { return }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            constant = keyboardSize.maxY
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.2
            let row = UInt(notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int ?? 0)
            layout(duration: duration, options: UIView.AnimationOptions(rawValue: row))
        }
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        constant = 0
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.2
        let row = UInt(notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int ?? 0)
        layout(duration: duration, options: UIView.AnimationOptions(rawValue: row))
    }
}
#endif
