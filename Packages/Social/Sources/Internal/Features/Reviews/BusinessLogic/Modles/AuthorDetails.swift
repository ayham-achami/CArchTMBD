//
//  AuthorDetails.swift
//  TMDB

import Foundation

public struct AuthorDetails: Codable {
    
    public let rating: Int?
    public let name: String
    public let username: String
    public let avatarPath: String?
}
