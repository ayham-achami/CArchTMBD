//  
//  StateRenderer.swift

import UIKit
import CArch

/// Протокол взаимодействия пользователя с модулем
public protocol StateRendererUserInteraction: AnyUserInteraction {
    
    func didAction(for state: StateRenderer.State)
}

/// Протокол причины отсутствия результатов
public protocol AnyNoResultReason {}

/// Объект содержащий логику отображения данных
public final class StateRenderer: UIRenderer, UIContentConfiguration {
    
    // MARK: - Renderer model
    public typealias ModelType = Model
    
    /// случай состояния
    public enum State {

        /// при попытке получения данных произошла ошибка
        case error
        /// идет загрузка данных
        case loading
        /// отсутствие данных `AnyNoResultReason` причины отсутствия результатов
        case noResult(AnyNoResultReason?)
    }
    
    public struct Model: UIModel {
        
        public let state: State
        public let image: UIImage?
        public let action: String?
        public let message: String?
        
        public init(state: State,
             image: UIImage? = nil,
             action: String? = nil,
             message: String? = nil) {
            self.state = state
            self.image = image
            self.action = action
            self.message = message
        }
    }

    // MARK: - Private properties
    private weak var interactional: StateRendererUserInteraction?
    
    private var state: State?
    private var content: UIContentUnavailableConfiguration?
    
    private var background: UIBackgroundConfiguration {
        var background = UIBackgroundConfiguration.clear()
        background.backgroundColor = Colors.primaryBack.color
        return background
    }
    
    // MARK: - Inits
    nonisolated public init(interactional: StateRendererUserInteraction) {
        self.interactional = interactional
    }
    
    // MARK: - Lifecycle
    public func moduleDidLoad() {
        rendering()
    }
    
    public func makeContentView() -> UIView & UIContentView {
        guard
            let content
        else { preconditionFailure("Set a content of renderer before") }
        return content.makeContentView()
    }
    
    public func updated(for state: UIConfigurationState) -> Self {
        guard
            let content
        else { preconditionFailure("Set a content of renderer before") }
        _ = content.updated(for: state)
        return self
    }
    
    // MARK: - Public methods
    public func set(content: StateRenderer.ModelType) {
        switch content.state {
        case .error:
            renderingErrorState(content.image, content.message, content.action)
        case .loading:
            renderingLoadingState(content.message)
        case .noResult:
            renderingNoResultsState(content.image, content.message, content.action)
        }
        state = content.state
    }
}

// MARK: - Renderer + IBAction
private extension StateRenderer {}

// MARK: - Private methods
private extension StateRenderer {

    func rendering() {}
    
    func renderingErrorState(_ image: UIImage?, _ message: String?, _ action: String?) {
        var error = UIContentUnavailableConfiguration.empty()
        defer { content = error }
        error.background = background
        error.image = image
        error.imageProperties.tintColor = Colors.danger.color
        error.text = "Error"
        error.textProperties.font = .Regular.headline
        error.secondaryText = message
        error.secondaryTextProperties.font = .Regular.body1
        guard let action else { return }
        error.button = buttonConfiguration(for: action)
        error.textToButtonPadding = 32
        error.buttonProperties.primaryAction = .init { [weak self] _ in
            self?.didTapAction()
        }
    }
    
    func renderingLoadingState(_ message: String?) {
        var loading = UIContentUnavailableConfiguration.loading()
        loading.background = background
        loading.textProperties.font = .Regular.headline
        loading.text = message
        content = loading
    }
    
    func renderingNoResultsState(_ image: UIImage?, _ message: String?, _ action: String?) {
        var search = UIContentUnavailableConfiguration.search()
        defer { content = search }
        search.background = background
        search.image = image
        search.imageProperties.tintColor = Colors.danger.color
        search.text = "No Results"
        search.textProperties.font = .Regular.headline
        search.secondaryText = message
        search.secondaryTextProperties.font = .Regular.body1
        guard let action else { return }
        search.button = buttonConfiguration(for: action)
        search.textToButtonPadding = 32
        search.buttonProperties.primaryAction = .init { [weak self] _ in
            self?.didTapAction()
        }
    }
    
    func buttonConfiguration(for action: String) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.bordered()
        configuration.buttonSize = .medium
        configuration.cornerStyle = .dynamic
        configuration.contentInsets = .init(top: 8, leading: 100, bottom: 8, trailing: 100)
        var container = AttributeContainer()
        container.foregroundColor = Colors.primaryText.color
        configuration.attributedTitle = .init(action, attributes: container)
        var background = configuration.background
        background.backgroundColor = Colors.secondary.color
        configuration.background = background
        return configuration
    }

    func didTapAction() {
        guard let state else { return }
        interactional?.didAction(for: state)
    }
}

#if DEBUG
// MARK: - Preview
extension StateRenderer: UIRendererPreview {
    
    final class InteractionalPreview: StateRendererUserInteraction {
        
        func didAction(for state: StateRenderer.State) {
            print("\(#function) State: \(state)")
        }
    }
    
    static let interactional: InteractionalPreview = .init()
    
    public static func preview() -> Self {
        let preview = Self.init(interactional: interactional)
        preview.moduleDidLoad()
        
        enum NoResult: AnyNoResultReason {
            case emptyResponse
        }
        
        preview.set(content: .init(state: .noResult(NoResult.emptyResponse),
                                   image: .init(systemName: "exclamationmark.arrow.triangle.2.circlepath"),
                                   action: "Retry request",
                                   message: "Could not load data"))
        return preview
    }
}

#Preview(String(describing: StateRenderer.self)) {
    let vc = UIViewController()
    let preview = StateRenderer.preview()
    vc.contentUnavailableConfiguration = preview
    return vc
}
#endif
