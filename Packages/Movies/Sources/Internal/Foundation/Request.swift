//
//  Request.swift

import CRest
import Foundation

extension EndPoint {
 
    static var movie: Self { .init(rawValue: "https://api.themoviedb.org/3/movie/") }
    
    static var person: Self { .init(rawValue: "https://api.themoviedb.org/3/person/") }
}
