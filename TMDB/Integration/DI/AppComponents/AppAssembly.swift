//
//  AppAssembly.swift
//

import CArch
import CArchSwinject
import Foundation

private struct AppDICollection: DIAssemblyCollection {
    
    var services: [DIAssembly] {
        [AppJWTControllerAssembly(),
         AppFactoryProviderAssembly(),
         BearerAuthenticatorAssembly(),
         ApplicationTMBDRouterAssembly()]
    }
}

extension LayoutAssemblyFactory {
    
    static func registerAppComponents() {
        let factory = LayoutAssemblyFactory()
        factory.record(AppDICollection())
        factory.record(NavigatorsDICollection())
    }
}
