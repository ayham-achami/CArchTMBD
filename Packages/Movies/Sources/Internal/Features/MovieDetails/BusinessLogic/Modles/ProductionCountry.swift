//
//  ProductionCountry.swift

import Foundation

public struct ProductionCountry: Codable {
    
    enum CodingKeys: String, CodingKey {
        
//        case code = "iso3166_1"
        case name
    }
    
//    public let code: String
    public let name: String
}
