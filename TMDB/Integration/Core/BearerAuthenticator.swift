//
//  BearerAuthenticator.swift
//

import CArch
import CArchSwinject
import CRest
import Foundation

final class BearerAuthenticatorAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.record(IOBearerAuthenticator.self, inScope: .autoRelease, configuration: nil) { resolver in
            BearerAuthenticator(provider: resolver.unravel(some: BearerCredentialProvider.self))
        }
    }
}

final class BearerAuthenticator: IOBearerAuthenticator {
    
    let refreshStatusCodes: [Int] = [401]
    let provider: BearerCredentialProvider
    let refreshRequest: Request = .init(endPoint: .init(rawValue: ""), path: "auth")
    
    init(provider: BearerCredentialProvider) {
        self.provider = provider
    }
}
