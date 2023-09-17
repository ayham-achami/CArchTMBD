//
//  ProductionCountry.swift

import CRest
import Foundation

struct ProductionCountry: Response {
    
    enum CodingKeys: String, CodingKey {
        
        //case code = "iso3166_1"
        case name
    }
    
    //let code: String
    let name: String
}
