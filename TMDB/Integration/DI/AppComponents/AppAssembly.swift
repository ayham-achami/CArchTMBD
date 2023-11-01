//
//  AppAssembly.swift
//  TMDB

import CArch
import Foundation
import CArchSwinject

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
