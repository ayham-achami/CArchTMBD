//
//  MoviesNavigator.swift

import TMDBCore
import Foundation

public enum MoviesBounds {}

@MainActor public protocol MoviesNavigator: Navigator {
    
    func destination(for bound: MoviesBounds) -> Destination
}
