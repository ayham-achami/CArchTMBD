//
//  JSONDecoder+Movies.swift

import Foundation

private let formatter: ISO8601DateFormatter = {
    .init()
}()

extension JSONDecoder {
    
    enum Error: Swift.Error {
        
        case parsing
    }
    
    static let `default`: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .custom { (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            formatter.formatOptions = [.withInternetDateTime]
            if let date = formatter.date(from: dateString) {
                return date
            }
            formatter.formatOptions = [.withFullDate, .withDashSeparatorInDate]
            if let date = formatter.date(from: dateString) {
                return date
            }
            throw Error.parsing
        }
        return decoder
    }()
}
