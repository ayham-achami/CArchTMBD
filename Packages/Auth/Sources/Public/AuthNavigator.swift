//
//  AuthNavigator.swift

import TMDBCore
import Foundation

public enum AuthBounds {
    
    case login
}

@MainActor public protocol AuthNavigator: Navigator {
    
    func destination(for bound: AuthBounds) -> Destination
}
