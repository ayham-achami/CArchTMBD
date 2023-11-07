//
//  Videos.swift
//

import CRest
import Foundation

// MARK: - Result
struct Video: Response {
    
    enum Kind: String, RawResponse {
    
        static var `default`: Video.Kind = .none
        
        case none
        case teaser
        case trailer
        case featurette
        case behindTheScenes
    }
    
    enum Site: String, RawResponse {
        
        static var `default`: Video.Site = .none
        
        case none
        case youTube
    }
    
    let id: String
    let key: String
    let name: String
    
    let size: Int
    let official: Bool
    let publishedAt: Date
    
    let site: Site
    let type: Kind
}

// MARK: - Videos
struct Videos: Response {
    
    let id: Int
    let results: [Video]
}
