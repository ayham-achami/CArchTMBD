//
//  Reviews.swift
//  TMDB

import Foundation

public struct Reviews: Codable {
    
    public let id: Int
    public let page: Int
    public let totalPages: Int
    public let totalResults: Int
    
    public let results: [Review]
}
