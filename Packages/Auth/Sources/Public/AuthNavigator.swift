//
//  AuthNavigator.swift
//

import Foundation
import TMDBCore

public enum AuthBounds {
    
    case login
}

@MainActor public protocol AuthNavigator: Navigator {
    
    func destination(for bound: AuthBounds) -> Destination
}
