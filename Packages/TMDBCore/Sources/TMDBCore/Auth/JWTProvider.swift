//
//  JWTProvider.swift
//

import Foundation

public enum AuthState {
    
    case guest
    case authorized
    case unauthorized
}

public protocol JWTProvider {
    
    typealias JWT = (access: String, refresh: String)
    
    var token: JWT { get  }
    
    var state: AuthState { get }
}

public protocol JWTController: JWTProvider {
    
    func rest()
    
    func set(_ token: JWT) throws
}
