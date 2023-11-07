//
//  MoviesMoviesAssemblyTest.swift
//

import CArch
import CArchSwinject
@testable import Movies
import XCTest

final class MoviesModuleAssemblyTests: XCTestCase {

    // Проверить, что модуль собирается
    func testAssemblyModule() {
        // Given
        let assembly = MoviesModule.PreviewBuilder().build()
        let viewController = assembly.node as? MoviesViewController

        // Then
        XCTAssertNotNil(viewController, "MoviesViewController is nil")
        
        XCTAssertNotNil(viewController?.moviesRenderer, "Renderer is nil")
        
        XCTAssertNotNil(viewController?.router, "MoviesRouter is nil")
        XCTAssertNotNil(viewController?.provider, "MoviesProvider is nil")
        
        guard
            let provider = (viewController?.provider as? MoviesProvider)
        else { XCTFail("Provider is not an MoviesProvider"); return }
        
        let presenter = Mirror(reflecting: provider)
            .children
            .first(where: { $0.label == "presenter" })?.value as? MoviesPresenter
        XCTAssertNotNil(presenter, "presenter in MoviesProvider is nil")
        
        if let presenter = presenter {
            let view = Mirror(reflecting: presenter)
                .children
                .first(where: { $0.label == "view" })?.value as? MoviesRenderingLogic
            XCTAssertNotNil(view, "view in MoviesPresenter is nil")
        }
    }
}
