//
//  Movie.swift

import Foundation

public struct Movie: Codable {

    let id: Int
    let voteCount: Int

    let genreIds: [Int]

    let popularity: Double
    let voteAverage: Double

    let video: Bool
    let adult: Bool

    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let originalTitle: String
    let originalLanguage: String

    let releaseDate: Date
}
