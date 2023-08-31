//
//  SecureAppDelegate.swift

import UIKit
import TMDBCore
import CArchSwinject

class SecureAppDelegate: UIResponder, UIApplicationDelegate {
    
    private var router: ApplicationTMBDRouter = .init()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let auther = AppJWTController()
        switch auther.state {
        case .guest, .unauthorized:
            router.showWelcome()
        case .authorized:
            router.showMain()
        }
        return true
    }
}
