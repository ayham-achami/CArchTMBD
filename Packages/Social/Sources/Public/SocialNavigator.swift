//
//  SocialNavigator.swift

import TMDBCore
import Foundation

public enum SocialBounds {}

@MainActor public protocol SocialNavigator: Navigator {
    
    func destination(for bound: SocialBounds) -> Destination
}
