//
//  Crew.swift

import Foundation

// MARK: - Crew
public struct Crew: Codable {
    
    public let id: Int
    public let gender: Int
    
    public let adult: Bool
    
    public let popularity: Double
    
    public let job: String
    public let name: String
    public let creditId: String
    public let department: String
    public let originalName: String
    public let profilePath: String?
    public let knownForDepartment: String
}
