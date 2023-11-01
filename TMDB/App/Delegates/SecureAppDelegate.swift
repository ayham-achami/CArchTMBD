//
//  SecureAppDelegate.swift

import UIKit
import CArch
import TMDBCore
import CArchSwinject

class SecureAppDelegate: UIResponder, UIApplicationDelegate {
    
    private lazy var router: ApplicationTMBDRouter = {
        LayoutAssemblyFactory().resolver.unravel(some: ApplicationTMBDRouter.self)
    }()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let authenticator = AppJWTController()
        switch authenticator.state {
        case .guest, .unauthorized:
            router.showWelcome()
        case .authorized:
            router.showMain()
        }
        return true
    }
}
