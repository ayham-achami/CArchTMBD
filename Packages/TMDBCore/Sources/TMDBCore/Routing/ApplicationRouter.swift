//
//  ApplicationRouter.swift
//

import CArch
import Foundation

public enum NavigationLevel {
    
    case main
    case secure
}

public struct Destination {
    
    public let module: CArchModule
    public let level: NavigationLevel
    
    public init(_ module: CArchModule, _ level: NavigationLevel) {
        self.module = module
        self.level = level
    }
}

@MainActor public protocol ApplicationRouter: AnyObject {
    
    func show(_ destination: Destination)
}
