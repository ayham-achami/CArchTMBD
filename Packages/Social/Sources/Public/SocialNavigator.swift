//
//  SocialNavigator.swift
//

import Foundation
import TMDBCore

public enum SocialBounds {}

@MainActor public protocol SocialNavigator: Navigator {
    
    func destination(for bound: SocialBounds) -> Destination
}
