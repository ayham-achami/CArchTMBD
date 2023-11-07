//
//  Credits.swift
//

import CRest
import Foundation

struct Credits: Response {
    
    let id: Int
    let cast: [Cast]
    let crew: [Crew]
}
