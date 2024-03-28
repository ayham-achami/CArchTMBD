//
//  VideosView.swift
//

import AVFoundation
import CArch
import CFoundation
import CUIKit
import TMDBUIKit
import UIKit

final class VideosView: UIView {
    
    var contentInset: UIEdgeInsets {
        get {
            collectionView.contentInset
        }
        set {
            collectionView.contentInset = newValue
            collectionView.scrollIndicatorInsets = newValue
        }
    }
    
    var videoInset: UIEdgeInsets = .init(top: 0, left: 16, bottom: 16, right: 0) {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = VideoCollectionViewLayout()
        layout.sideItemAlpha = 1.0
        layout.sideItemScale = 1.0
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: 300, height: 250)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(factory: VideoCellFactory.self)
        return view
    }()
    
    private var playItem: DispatchWorkItem?
    private var content: [VideoCell.Model] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        rendering()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        rendering()
    }
    
    deinit {
        playItem?.cancel()
        playItem = nil
    }
    
    func set(content: [VideoCell.Model]) {
        self.content = content
        collectionView.reloadData()
    }
    
    func rendering() {
        backgroundColor = .clear
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: - VideosView + UICollectionViewDataSource
extension VideosView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        content.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(by: VideoCellFactory.self, for: indexPath, models: content, delegate: self)
    }
}

// MARK: - VideosView + UICollectionViewDelegateFlowLayout
extension VideosView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: bounds.width - videoInset.left - videoInset.right,
              height: 280 - videoInset.top - videoInset.bottom)
    }
}

// MARK: - VideosView + UICollectionViewDelegate
extension VideosView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        content[indexPath.row].player.pause()
    }
}

// MARK: - VideosView - VideoCellDelegate
extension VideosView: VideoCellDelegate {
    
    func videoCell(_ videoCell: VideoCell, isReadyForDisplay player: AVPlayer) {
        print("Hiiii")
//        guard
//            collectionView.visibleCells.contains(videoCell)
//        else { return }
//        player.play()
    }
}

#if DEBUG
// MARK: - Preview
#Preview(String(describing: VideosView.self)) {
    let preview = VideosView(frame: .zero)
    preview.set(
        content: (1...10).map { _ in
            let lhs = URL(
                string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"
            )!
            let playItem = AVPlayerItem(url: lhs)
            let player = AVPlayer(playerItem: playItem)
            return .init(player: player)
        }
    )
    preview.translatesAutoresizingMaskIntoConstraints = false
    let vc = UIViewController()
    vc.view.addSubview(preview)
    NSLayoutConstraint.activate([preview.heightAnchor.constraint(equalToConstant: 300),
                                 preview.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor),
                                 preview.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
                                 preview.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor)])
    
    return vc
}
#endif
