//
//  FactoryProvider .swift
//

import CArch
import CArchSwinject
import Foundation
import TMDBCore

final class AppFactoryProvider: FactoryProvider {
    
    var factory: LayoutAssemblyFactory {
        LayoutAssemblyFactory()
    }
}

final class AppFactoryProviderAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.record(some: FactoryProvider.self) { _ in
            AppFactoryProvider()
        }
    }
}
