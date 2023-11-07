//
//  MoviesList.swift
//

import CRest
import Foundation

struct MoviesList: Response {

    let page: Int
    let totalPages: Int
    let totalResults: Int
    
    let results: [Movie]
}
