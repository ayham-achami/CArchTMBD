//
//  Person.swift
//

import CRest
import Foundation

struct Person: Response {
    
    enum Gender: Int, RawResponse {
        
        static var `default`: Person.Gender = .none
        
        case none
        case female
        case male
        case nonBinary
    }
    
    let id: Int
    let gender: Gender
    
    let popularity: Double
    
    let adult: Bool
    
    let name: String
    let biography: String
    let knownForDepartment: String
    
    let birthday: Date?
    let deathday: Date?
    
    let imdbId: String?
    let homepage: String?
    let profilePath: String?
    let placeOfBirth: String?
    
    let alsoKnownAs: [String]
}
