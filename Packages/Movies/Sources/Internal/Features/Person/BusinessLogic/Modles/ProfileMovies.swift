//
//  ProfileMovies.swift
//

import CRest
import Foundation

// MARK: - Cast
struct MovieCast: Response {
    
    let id: Int
    let voteCount: Int
    let genreIds: [Int]
    
    let video: Bool
    let adult: Bool

    let popularity: Double
    let voteAverage: Double
    
    let title: String
    let overview: String
    let originalTitle: String
    let originalLanguage: String
  
    let order: Int?
    
    let job: String?
    let creditId: String
    let character: String?
    let department: String?
    let posterPath: String?
    let releaseDate: String?
    let backdropPath: String?
}

struct ProfileMovies: Response {
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case acting = "cast"
        case production = "crew"
    }
    
    let id: Int
    let acting: [MovieCast]
    let production: [MovieCast]
}
