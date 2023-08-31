//
//  Movies.swift

import Foundation

public struct Movies: Codable {

    let page: Int
    let totalPages: Int
    let totalResults: Int
    
    let results: [Movie]
}
