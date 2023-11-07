//
//  UIWindow+TMDB.swift
//

import UIKit

extension UIWindow.Level {
    
    static let main: UIWindow.Level = .normal
    static let secure: UIWindow.Level = .init(above: .main)
        
    private init(above level: UIWindow.Level) {
        self.init(rawValue: level.rawValue + 1)
    }
}

extension UIWindow {

    convenience init(level: UIWindow.Level) {
        let windowScene = UIApplication.shared
                        .connectedScenes
                        .filter { $0.activationState == .foregroundActive }
                        .first
        if let windowScene = windowScene as? UIWindowScene {
            self.init(windowScene: windowScene)
        } else {
            self.init(frame: UIScreen.main.bounds)
        }
        windowLevel = level
        backgroundColor = .clear
        isHidden = true
    }
}
