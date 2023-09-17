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
        stopAnimationIfNeeded()
        secureWindow.rootViewController = module.node
        secureWindow.rootViewController?.viewIfLoaded?.alpha = 0
        secureWindow.isHidden = false
        secureWindow.makeKeyAndVisible()
        
        mainWindow.isHidden = true
        mainWindow.resignKey()
        
        animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: animateDuration, delay: 0, animations: {
            self.secureWindow.rootViewController?.viewIfLoaded?.alpha = 1
        }, completion: { _ in
            self.mainWindow.rootViewController = nil
            self.animator = nil
        })
        
    }
    
    func unlock(with module: CArchModule) {
        stopAnimationIfNeeded()
        mainWindow.rootViewController = module.node
        mainWindow.rootViewController?.viewIfLoaded?.alpha = 0
        mainWindow.isHidden = false
        mainWindow.makeKeyAndVisible()
        
        secureWindow.isHidden = true
        secureWindow.resignKey()
        
        animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: animateDuration, delay: 0, animations: {
            self.mainWindow.rootViewController?.viewIfLoaded?.alpha = 1
        }, completion: { _ in
            self.secureWindow.rootViewController = nil
            self.animator = nil
        })
    }
    
    private func stopAnimationIfNeeded() {
        guard let animator, animator.isRunning else { return }
        animator.stopAnimation(false)
        animator.finishAnimation(at: .current)
    }
}
