//
//  Cast.swift

import CRest
import Foundation

struct Cast: Response {
    
    let id: Int
    let order: Int
    let castId: Int
    let gender: Int
    
    let adult: Bool
    
    let popularity: Double
    
    let name: String
    let creditId: String
    let character: String
    let originalName: String
    let profilePath: String?
    let knownForDepartment: String
}
