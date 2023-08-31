//
//  Cast.swift

import Foundation

public struct Cast: Codable {
    
    public let id: Int
    public let order: Int
    public let castId: Int
    public let gender: Int
    
    public let adult: Bool
    
    public let popularity: Double
    
    public let name: String
    public let creditId: String
    public let character: String
    public let originalName: String
    public let profilePath: String?
    public let knownForDepartment: String
}
