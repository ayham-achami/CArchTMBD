//
//  MovieDetails.swift

import CRest
import Foundation

// MARK: - MovieDetails
struct MovieDetails: Response {
    
    let id: Int
    let budget: Int
    let revenue: Int
    let runtime: Int
    let voteCount: Int
    
    let video: Bool
    let adult: Bool
    
    let popularity: Double
    let voteAverage: Double

    let title: String
    let imdbId: String
    let status: String
    let tagline: String
    let overview: String
    let homepage: String
    let posterPath: String
    let backdropPath: String
    let originalTitle: String
    let originalLanguage: String
    
    let releaseDate: Date
    
    let genres: [Genre]
    let spokenLanguages: [SpokenLanguage]
    let productionCompanies: [ProductionCompany]
    let productionCountries: [ProductionCountry]
}
