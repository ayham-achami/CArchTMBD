//
//  ApplicationRouter.swift
//

import CArchSwinject
import UIKit

@main
class AppDelegate: SecureAppDelegate {
    
    override init() {
        super.init()
        LayoutAssemblyFactory.registerAppComponents()
    }
}
