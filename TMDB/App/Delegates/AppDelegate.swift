//
//  ApplicationRouter.swift
//  TMDB

import UIKit
import CArchSwinject

@main
class AppDelegate: SecureAppDelegate {
    
    override init() {
        LayoutAssemblyFactory().record(AppAssembly.self)
        super.init()
    }
    
    override func application(_ application: UIApplication, 
                              didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
