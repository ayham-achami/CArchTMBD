//
//  ApplicationRouter.swift
//  TMDB

import UIKit
import CArchSwinject

@main
class AppDelegate: SecureAppDelegate {
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        LayoutAssemblyFactory().record(AppAssembly.self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
