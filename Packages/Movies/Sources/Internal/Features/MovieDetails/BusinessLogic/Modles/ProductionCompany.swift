//
//  ProductionCompany.swift
//

import CRest
import Foundation

struct ProductionCompany: Response {
    
    let id: Int
    let name: String
    let logoPath: String?
    let originCountry: String
}
