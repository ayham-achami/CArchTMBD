//
//  Crew.swift

import CRest
import Foundation

// MARK: - Crew
struct Crew: Response {
    
    let id: Int
    let gender: Int
    
    let adult: Bool
    
    let popularity: Double
    
    let job: String
    let name: String
    let creditId: String
    let department: String
    let originalName: String
    let profilePath: String?
    let knownForDepartment: String
}
