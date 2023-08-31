//
//  AuthNavigator.swift

import TMDBCore
import Foundation

public enum AtuhBounds {
    
    case login
}

@MainActor public protocol AuthNavigator: Navigator {
    
    func destination(for bound: AtuhBounds) -> Destination
}
