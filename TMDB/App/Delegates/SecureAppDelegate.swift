//
//  SecureAppDelegate.swift

import UIKit
import TMDBCore
import CArchSwinject

class SecureAppDelegate: UIResponder, UIApplicationDelegate {
    
    @UnsafeInjectable(LayoutAssemblyFactory.self)
    private var router: ApplicationTMBDRouter
    
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
