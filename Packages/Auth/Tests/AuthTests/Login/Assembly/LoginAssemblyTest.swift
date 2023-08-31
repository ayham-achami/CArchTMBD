//
//  LoginLoginAssemblyTest.swift

import XCTest
@testable import Auth

final class LoginModuleAssemblyTests: XCTestCase {
    
    // Проверить, что модуль собирается
    func testAssemblyModule() {
        // Given
        let assembly = LoginModule.PreviewBuilder().build()
        let viewController = assembly.node as? LoginViewController

        // Then
        XCTAssertNotNil(viewController, "LoginViewController is nil")
        
        XCTAssertNotNil(viewController?.renderer, "Renderer is nil")
        
        XCTAssertNotNil(viewController?.router, "LoginRouter is nil")
        XCTAssertNotNil(viewController?.provider, "LoginProvider is nil")
        
        guard
            let provider = (viewController?.provider as? LoginProvider)
        else { XCTFail("Provider is not an LoginProvider"); return }
        
        let presenter = Mirror(reflecting: provider)
            .children
            .first(where: { $0.label == "presenter" })?.value as? LoginPresenter
        XCTAssertNotNil(presenter, "presenter in LoginProvider is nil")
        
        if let presenter = presenter {
            let view = Mirror(reflecting: presenter)
                .children
                .first(where: { $0.label == "view" })?.value as? LoginRenderingLogic
            XCTAssertNotNil(view, "view in LoginPresenter is nil")
        }
    }
}
