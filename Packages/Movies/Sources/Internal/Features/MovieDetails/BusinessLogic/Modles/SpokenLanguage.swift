//
//  SpokenLanguage.swift

import Foundation

public struct SpokenLanguage: Codable {
    
    enum CodingKeys: String, CodingKey {
        
        case name
        case englishName
        //case code = "iso6391"
    }
    
    public let englishName: String
    //public let code: String
    public let name: String
}
