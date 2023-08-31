//
//  ProductionCompany.swift

import Foundation

public struct ProductionCompany: Codable {
    
    public let id: Int
    public let name: String
    public let logoPath: String?
    public let originCountry: String
}
