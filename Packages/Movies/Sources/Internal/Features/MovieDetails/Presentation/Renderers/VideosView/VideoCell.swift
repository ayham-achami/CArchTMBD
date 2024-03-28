//
//  VideoCell.swift
//

import AlamofireImage
import AVKit
import CArch
import CUIKit
import TMDBUIKit
import UIKit

struct VideoCellFactory: UIDelegableReusableViewFactory {
    
    typealias View = VideoCell
    typealias Model = VideoCell.Model
    typealias Delegate = VideoCellDelegate
    
    private let model: Model
    private let delegate: Delegate
    
    init(_ model: VideoCell.Model, _ delegate: Delegate) {
        self.model = model
        self.delegate = delegate
    }
    
    func rendering(_ view: VideoCell) {
        view.delegate = delegate
        view.set(content: model)
    }
}

protocol VideoCellDelegate: AnyObject {
    
    func videoCell(_ videoCell: VideoCell, isReadyForDisplay player: AVPlayer)
}

class VideoCell: UICollectionViewCell {
 
    struct Model: ViewModel {
        
        let player: AVPlayer
    }
    
    private let playerView: CardView = {
        let view = CardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let videoPlayerContentView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let playerViewController: AVPlayerViewController = {
        let view = AVPlayerViewController()
        return view
    }()
    
    private lazy var playerCoordinator: PlayerViewControllerCoordinator = {
        PlayerViewControllerCoordinator(playerViewController, delegate: self)
    }()
    
    fileprivate weak var delegate: VideoCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        rendering()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        rendering()
    }
    
    override func prepareForReuse() {
        playerViewController.player?.pause()
        playerViewController.player = nil
    }
    
    func set(content: Model) {
        playerCoordinator.set(content.player, play: false)
    }
    
    func rendering() {
        contentView.addSubview(playerView)
        NSLayoutConstraint.activate([
            playerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            playerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            playerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        playerView.addSubview(videoPlayerContentView)
        NSLayoutConstraint.activate([
            videoPlayerContentView.topAnchor.constraint(equalTo: playerView.topAnchor, constant: 8),
            videoPlayerContentView.bottomAnchor.constraint(equalTo: playerView.bottomAnchor, constant: -8),
            videoPlayerContentView.leadingAnchor.constraint(equalTo: playerView.leadingAnchor, constant: 8),
            videoPlayerContentView.trailingAnchor.constraint(equalTo: playerView.trailingAnchor, constant: -8)
        ])
        
        playerCoordinator.embed(into: videoPlayerContentView)
    }
}

// MARK: - VideoCell + PlayerViewControllerCoordinatorDelegate
extension VideoCell: PlayerViewControllerCoordinatorDelegate {
    
    func playerViewControllerCoordinatorWillDismiss(_ coordinator: PlayerViewControllerCoordinator) {
    }
    
    func playerViewControllerCoordinator(_ coordinator: PlayerViewControllerCoordinator, readyForDisplay player: AVPlayer) {
        delegate?.videoCell(self, isReadyForDisplay: player)
    }
    
    func playerViewControllerCoordinator(_ coordinator: PlayerViewControllerCoordinator,
                                         restoreUIForPIPStop completion: @escaping (Bool) -> Void) {
    }
}

#if DEBUG
// MARK: - Preview
#Preview(String(describing: VideoCell.self)) {
    let preview = VideoCell(frame: .zero)
    let lhs = URL(
        string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"
    )!
    let playItem = AVPlayerItem(url: lhs)
    let player = AVPlayer(playerItem: playItem)
    preview.set(content: .init(player: player))
    preview.translatesAutoresizingMaskIntoConstraints = false
    let vc = UIViewController()
    vc.view.addSubview(preview)
    NSLayoutConstraint.activate([preview.widthAnchor.constraint(equalToConstant: 300),
                                 preview.heightAnchor.constraint(equalToConstant: 200),
                                 preview.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
                                 preview.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor)])
    
    return vc
}
#endif
