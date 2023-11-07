//
//  MoviesNavigator.swift
//

import Foundation
import TMDBCore

public enum MoviesBounds {}

@MainActor public protocol MoviesNavigator: Navigator {
    
    func destination(for bound: MoviesBounds) -> Destination
}
