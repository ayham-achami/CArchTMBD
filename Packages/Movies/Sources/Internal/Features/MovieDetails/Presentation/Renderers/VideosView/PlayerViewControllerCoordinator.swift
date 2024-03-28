//
//  PlayerViewControllerCoordinator.swift
//

import AVFoundation
import AVKit

protocol PlayerViewControllerCoordinatorDelegate: AnyObject {
    
    func playerViewControllerCoordinatorWillDismiss(_ coordinator: PlayerViewControllerCoordinator)
    
    func playerViewControllerCoordinator(_ coordinator: PlayerViewControllerCoordinator, readyForDisplay player: AVPlayer)
    
    func playerViewControllerCoordinator(_ coordinator: PlayerViewControllerCoordinator, restoreUIForPIPStop completion: @escaping (Bool) -> Void)
}

final class PlayerViewControllerCoordinator: NSObject {
    
    struct Status: OptionSet {
        
        let rawValue: Int
        
        static let embeddedInline = Status(rawValue: 1 << 0)
        static let fullScreenActive = Status(rawValue: 1 << 1)
        static let beingPresented = Status(rawValue: 1 << 2)
        static let beingDismissed = Status(rawValue: 1 << 3)
        static let pictureInPictureActive = Status(rawValue: 1 << 4)
    }
    
    private(set) var status: Status = []

    private weak var fullScreenViewController: UIViewController?
    private weak var delegate: PlayerViewControllerCoordinatorDelegate?
    private var readyForDisplayObservation: NSKeyValueObservation?
    
    private let playerViewController: AVPlayerViewController
    
    init(_ playerViewController: AVPlayerViewController,
         delegate: PlayerViewControllerCoordinatorDelegate) {
        self.playerViewController = playerViewController
    }
    
    deinit {
        readyForDisplayObservation?.invalidate()
        readyForDisplayObservation = nil
    }
    
    func set(_ player: AVPlayer, play: Bool = true) {
        readyForDisplayObservation?.invalidate()
        readyForDisplayObservation = nil
        playerViewController.player = player
        guard play else { return }
        player.play()
        readyForDisplayObservation = playerViewController.observe(\.isReadyForDisplay) { [weak self] observed, _ in
            guard
                let self,
                observed.isReadyForDisplay,
                let player = observed.player
            else { return }
            self.delegate?.playerViewControllerCoordinator(self, readyForDisplay: player)
        }
    }
    
    func embed(into container: UIView, insets: UIEdgeInsets = .zero) {
        removePlayerParentIfNeeded()
        status.insert(.embeddedInline)
        container.addSubview(playerViewController.view)
        playerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerViewController.view.topAnchor.constraint(equalTo: container.topAnchor, constant: insets.top),
            playerViewController.view.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: insets.left),
            playerViewController.view.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -insets.bottom),
            playerViewController.view.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -insets.right)
        ])
    }
    
    func presentFullScreen(on presentingViewController: UIViewController, autoPlay: Bool = true) {
        guard
            !status.contains(.fullScreenActive)
        else { return }
        removePlayerParentIfNeeded()
        presentingViewController.present(playerViewController, animated: true) { [weak self] in
            guard
                autoPlay,
                let player = self?.playerViewController.player,
                player.timeControlStatus == .paused
            else { return }
            player.play()
        }
    }
    
    func dismissFullScreen(autoPlay: Bool = true, completion: (() -> Void)? = nil) {
        if let fullScreenViewController {
            fullScreenViewController.dismiss(animated: true) { [weak self] in
                if autoPlay, let player = self?.playerViewController.player, player.timeControlStatus == .paused {
                    player.play()
                }
                completion?()
                self?.status.remove(.fullScreenActive)
            }
        } else if let completion {
            DispatchQueue.main.async { completion() }
        }
    }
    
    private func removePlayerParentIfNeeded() {
        guard
            status.contains(.embeddedInline)
        else { return }
        playerViewController.willMove(toParent: nil)
        playerViewController.view.removeFromSuperview()
        playerViewController.removeFromParent()
        status.remove(.embeddedInline)
    }
}

// MARK: - PlayerViewControllerCoordinator + AVPlayerViewControllerDelegate
extension PlayerViewControllerCoordinator: AVPlayerViewControllerDelegate {
    
    func playerViewControllerWillStartPictureInPicture(_ playerViewController: AVPlayerViewController) {
        status.insert(.pictureInPictureActive)
    }
    
    func playerViewController(_ playerViewController: AVPlayerViewController, failedToStartPictureInPictureWithError error: Error) {
        status.remove(.pictureInPictureActive)
    }
    
    func playerViewControllerDidStopPictureInPicture(_ playerViewController: AVPlayerViewController) {
        status.remove(.pictureInPictureActive)
    }
    
    func playerViewController(_ playerViewController: AVPlayerViewController,
                              willBeginFullScreenPresentationWithAnimationCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        status.insert([.fullScreenActive, .beingPresented])
        coordinator.animate(alongsideTransition: nil) { context in
            self.status.remove(.beingPresented)
            if context.isCancelled {
                self.status.remove(.fullScreenActive)
            } else {
                self.fullScreenViewController = context.viewController(forKey: .to)
            }
        }
    }
    
    func playerViewController(_ playerViewController: AVPlayerViewController,
                              willEndFullScreenPresentationWithAnimationCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        status.insert([.beingDismissed])
        delegate?.playerViewControllerCoordinatorWillDismiss(self)
        
        coordinator.animate(alongsideTransition: nil) { context in
            self.status.remove(.beingDismissed)
            if !context.isCancelled {
                self.status.remove(.fullScreenActive)
            }
        }
    }

    func playerViewController(_ playerViewController: AVPlayerViewController,
                              restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        if let delegate {
            delegate.playerViewControllerCoordinator(self, restoreUIForPIPStop: completionHandler)
        } else {
            completionHandler(false)
        }
    }
}
