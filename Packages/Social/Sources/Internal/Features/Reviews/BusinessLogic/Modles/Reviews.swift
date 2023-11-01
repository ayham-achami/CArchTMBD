//
//  Reviews.swift
//  TMDB

import CRest
import Foundation

public struct Reviews: Response {
    
    public let id: Int
    public let page: Int
    public let totalPages: Int
    public let totalResults: Int
    
    public let results: [Review]
}
