//  MoviesRenderer.swift

import UIKit
import CArch
import TMDBUIKit

/// Протокол взаимодействия пользователя с модулем
protocol MoviesRendererUserInteraction: AnyUserInteraction {
    
    /// Вызывается когда требуется загрузить еще фильмы
    func didRequestMoreMovies()
    
    /// Вызывается когда требуется загрузить детали фильма
    /// - Parameter id: ID фильма
    func didRequestMovieDetails(with id: Int)
}

/// Объект содержащий логику отображения данных
final class MoviesRenderer: UICollectionView, UIRenderer {
    
    // MARK: - Renderer model
    typealias ModelType = [MovieCell.Model]

    private let cellId = "\(String(describing: MoviesRenderer.self)).\(String(describing: MovieCell.self))"
    
    // MARK: - Private properties
    private weak var interactional: MoviesRendererUserInteraction?
    private var content: ModelType = []
    
    // MARK: - Inits
    init(interactional: MoviesRendererUserInteraction) {
        super.init(frame: .zero, collectionViewLayout: MoviesLayout())
        self.interactional = interactional
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    func moduleDidLoad() {
        delegate = self
        dataSource = self
        register(MovieCell.self, forCellWithReuseIdentifier: cellId)
        rendering()
    }
    
    // MARK: - Public methods
    func set(content: ModelType) {
        self.content.append(contentsOf: content)
        reloadData()
    }
}

// MARK: - Renderer + IBAction
private extension MoviesRenderer {}

// MARK: - Private methods
private extension MoviesRenderer {
    
    func rendering() {
        backgroundColor = Colors.primaryBack.color
    }
}

// MARK: - MoviesRenderer + UICollectionViewDataSource
extension MoviesRenderer: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        content.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MovieCell
        else { preconditionFailure("Cell is not a instance of MovieCell") }
        let model = content[indexPath.row]
        cell.set(content: model)
        return cell
    }
}

// MARK: - MoviesRenderer + UICollectionViewDelegate
extension MoviesRenderer: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let model = content[indexPath.row]
        interactional?.didRequestMovieDetails(with: model.id)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard indexPath.row == content.count - 1 else { return }
        interactional?.didRequestMoreMovies()
    }
}

// MARK: - Preview
extension MoviesRenderer: UIRendererPreview {
    
    final class InteractionalPreview: MoviesRendererUserInteraction {
        
        func didRequestMoreMovies() {
            print(#function)
        }
        
        func didRequestMovieDetails(with id: Int) {
            print(#function)
        }
    }
    
    static let interactional: InteractionalPreview = .init()
    
    static func preview() -> Self {
        let preview = Self.init(interactional: interactional)
        preview.moduleDidLoad()
        preview.set(content: (1...10).map { id in
            let path = (id % 2) == 0 ? "/vZloFAK7NmvMGKE7VkF5UHaz0I.jpg" : "/ym1dxyOk4jFcSl4Q2zmRrA5BEEN.jpg"
            return .init(id: id,
                         name: "John Wick: Chapter 4",
                         rating: 3.8,
                         posterPath: path,
                         releaseDate: "03/24/2023")
        })
        return preview
    }
}

#if DEBUG
#Preview(String(describing: MoviesRenderer.self)) {
    MoviesRenderer.preview()
}
#endif
