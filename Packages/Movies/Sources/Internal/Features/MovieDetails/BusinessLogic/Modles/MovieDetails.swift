//
//  MovieDetails.swift

import Foundation

// MARK: - MovieDetails
public struct MovieDetails: Codable {
    
    public let id: Int
    public let budget: Int
    public let revenue: Int
    public let runtime: Int
    public let voteCount: Int
    
    public let video: Bool
    public let adult: Bool
    
    public let popularity: Double
    public let voteAverage: Double

    public let title: String
    public let imdbId: String
    public let status: String
    public let tagline: String
    public let overview: String
    public let homepage: String
    public let posterPath: String
    public let backdropPath: String
    public let originalTitle: String
    public let originalLanguage: String
    
    public let releaseDate: Date
    
    public let genres: [Genre]
    public let spokenLanguages: [SpokenLanguage]
    public let productionCompanies: [ProductionCompany]
    public let productionCountries: [ProductionCountry]
}
