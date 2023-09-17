//
//  SpokenLanguage.swift

import CRest
import Foundation

struct SpokenLanguage: Response {
    
    enum CodingKeys: String, CodingKey {
        
        case name
        case englishName
        //case code = "iso6391"
    }
    
    let englishName: String
    //let code: String
    let name: String
}
