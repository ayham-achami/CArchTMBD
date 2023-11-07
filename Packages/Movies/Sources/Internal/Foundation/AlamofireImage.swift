//
//  AlamofireImage.swift
//

import AlamofireImage
import UIKit

extension UIImageView {
    
    private static let loaderTag = -1001
    
    func setImage(with base: URL, path: String, showLoader: Bool = false, union: UIImageView? = nil) {
        if showLoader { addLoader() }
        af.setImage(withURL: base.appending(path: path), completion: { [weak self] response in
            switch response.result {
            case let .success(image):
                union?.image = image
            case let .failure(error):
                guard !error.isCancelled else { return }
            }
            self?.removeLoader(from: self)
            self?.removeLoader(from: union)
        })
    }
    
    func cancelImageLoading(removeLoader: Bool = false) {
        af.cancelImageRequest()
        guard
            removeLoader,
            let view = subviews.view(at: Self.loaderTag, cats: UIActivityIndicatorView.self)
        else { return }
        view.stopAnimating()
        view.removeFromSuperview()
    }
    
    private func addLoader() {
        let loader = if let view = subviews.view(at: Self.loaderTag, cats: UIActivityIndicatorView.self) {
            view
        } else {
            createLoader()
        }
        loader.startAnimating()
    }
    
    private func createLoader() -> UIActivityIndicatorView {
        let loader = UIActivityIndicatorView(style: .medium)
        loader.hidesWhenStopped = true
        loader.tag = Self.loaderTag
        loader.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loader)
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        return loader
    }
    
    private func removeLoader(from view: UIImageView?) {
        guard
            let view = view?.subviews.view(at: Self.loaderTag, cats: UIActivityIndicatorView.self)
        else { return }
        view.stopAnimating()
        view.removeFromSuperview()
    }
}

private extension Array where Element == UIView {
    
    func view<View>(at tag: Int, cats: View.Type) -> View? where View: UIView {
        compactMap { $0 as? View }.first { $0.tag == tag }
    }
}
