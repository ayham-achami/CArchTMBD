//
//  FactoryProvider .swift
//  TMDB

import CArch
import TMDBCore
import Foundation
import CArchSwinject

final class AppFactoryProvider: FactoryProvider {
    
    var factroy: LayoutAssemblyFactory {
        LayoutAssemblyFactory()
    }
}

final class AppFactoryProviderAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.record(FactoryProvider.self, inScope: .autoRelease) { _ in
            AppFactoryProvider()
        }
    }
}
