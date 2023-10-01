//
//  ProfileImages.swift

import CRest
import Foundation

// MARK: - ProfileImages
struct ProfileImages: Response {
 
    let id: Int
    let profiles: [Profile]
    
    struct Profile: Response {

        let filePath: String
        
        let width: Int
        let height: Int
        let aspectRatio: Double

        let voteCount: Int
        let voteAverage: Double
    }
}
