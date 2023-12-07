//
//  JSON.swift
//

import Foundation

private let formatter: ISO8601DateFormatter = {
    .init()
}()

extension JSONDecoder {
    
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
    
    enum Error: Swift.Error {
        
        case parsing
    }
}

extension JSONEncoder {
    
    static let `default`: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = Calendar.current.timeZone
        formatter.formatOptions = [.withFullDate, .withDashSeparatorInDate]
        encoder.dateEncodingStrategy = .custom { date, encoder in
            var container = encoder.singleValueContainer()
            let dateString = formatter.string(from: date)
            try container.encode(dateString)
        }
        return encoder
    }()
}
