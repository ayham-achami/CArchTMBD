//
//  ProfileImages.swift
//

import CRest
import Foundation

// MARK: - ProfileImages
struct ProfileImages: Response {
    
    struct Profile: Response {

        let filePath: String
        
        let width: Int
        let height: Int
        let aspectRatio: Double

        let voteCount: Int
        let voteAverage: Double
    }
    
    let id: Int
    let profiles: [Profile]
}
