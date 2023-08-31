//
//  CoreDICollection.swift
//  TMDB

import CArch
import Foundation

final class CoreDICollection: DIAssemblyCollection {
    
    var services: [DIAssembly] {
        [AppJWTControllerAssembly(),
         AppFactoryProviderAssembly(),
         ApplicationTMBDRouterAssembly()]
    }
}
