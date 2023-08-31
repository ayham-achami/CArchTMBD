//
//  Review.swift
//  TMDB

import Foundation

public struct Review: Codable {
    
    public let id: String
    public let url: String
    public let author: String
    public let content: String
    public let createdAt: String
    public let updatedAt: String
    public let authorDetails: AuthorDetails
}
