//  
//  PersonService.swift
//  
//
//  Created by Ayham Hylam on 12.09.2023.
//

import CArch
import CRest
import TMDBCore
import Foundation

// MAR: - DI
final class PersonServiceAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.record(PersonService.self, inScope: .autoRelease) { resolver in
            PersonServiceImplementation(io: resolver.unravel(ConcurrencyIO.self)!)
        }
    }
}

private extension Request {
 
    static func person(id: Int, language: String? = nil) -> Self {
        enum Keys: String, URLQueryKeys {
            
            case language
        }
        let url = DynamicURL
            .keyed(by: Keys.self)
            .with(endPoint: .person)
            .with(pathComponent: "\(id)")
            .with(value: language, key: .language)
            .build()
        return .init(url)
    }
}

// MARK: - Public
@MaintenanceActor protocol PersonService: BusinessLogicService {
    
    func fetchPerson(with id: Int) async throws -> Person
}

// MARK: - Private
private final class PersonServiceImplementation: PersonService {
    
    private let io: ConcurrencyIO
    
    nonisolated init(io: ConcurrencyIO) {
        self.io = io
    }
    
    func fetchPerson(with id: Int) async throws -> Person {
        try await io.fetch(for: .person(id: id), response: Person.self, encoding: .URL(.default))
    }
}
