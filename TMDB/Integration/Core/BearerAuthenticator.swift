//
//  BearerAuthenticator.swift
//  TMDB

import CArch
import CRest
import Foundation
import CArchSwinject

final class BearerAuthenticator: IOBearerAuthenticator {
    
    let refreshStatusCodes: [Int] = [401]
    let provider: BearerCredentialProvider
    let refreshRequest: Request = .init(endPoint: .init(rawValue: ""), path: "auth")
    
    init(provider: BearerCredentialProvider) {
        self.provider = provider
    }
}

final class BearerAuthenticatorAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.record(IOBearerAuthenticator.self, inScope: .autoRelease) { resolver in
            BearerAuthenticator(provider: resolver.unravel(BearerCredentialProvider.self)!)
        }
    }
}
