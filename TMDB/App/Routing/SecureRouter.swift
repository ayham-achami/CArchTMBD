//
//  SecureRoutingLogic.swift
//  TMDB

import CArch
import UIKit

@MainActor protocol SecureRoutingLogic {
    
    var isLocked: Bool { get }

    func lock(with module: CArchModule)
    
    func unlock(with module: CArchModule)
}

@MainActor final class SecureRouter: SecureRoutingLogic {
    
    var isLocked: Bool {
        secureWindow.isKeyWindow
    }
    
    private let animateDuration = 0.3
    private var animator: UIViewPropertyAnimator?
    
    private lazy var secureWindow: UIWindow = {
        .init(level: .secure)
    }()
    
    private lazy var mainWindow: UIWindow = {
        .init(level: .main)
    }()
    
    func lock(with module: CArchModule) {
        mainWindow.rootViewController = nil
        if let animator, animator.isRunning {
            animator.stopAnimation(false)
            animator.finishAnimation(at: .current)
        }
        secureWindow.rootViewController = module.node
        secureWindow.makeKeyAndVisible()
    }
    
    func unlock(with module: CArchModule) {
        mainWindow.rootViewController = module.node
        mainWindow.makeKeyAndVisible()
        animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: animateDuration, delay: 0, animations: {
            self.secureWindow.rootViewController?.viewIfLoaded?.alpha = 0
        }, completion: { _ in
            self.secureWindow.isHidden = true
            self.animator = nil
        })
    }
}
