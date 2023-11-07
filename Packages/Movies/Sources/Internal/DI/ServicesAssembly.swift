//
//  ServicesAssembly.swift
//

import CArch
import CArchSwinject
import Foundation
import TMDBCore

struct PersonServices: DIAssemblyCollection {
    
    var services: [DIAssembly] {
        [RestIOAssembly(),
         PersonServiceAssembly()]
    }
}

struct MoviesServices: DIAssemblyCollection {
    
    var services: [DIAssembly] {
        [RestIOAssembly(),
         MoviesServiceAssembly()]
    }
}

struct MovieDetailsServices: DIAssemblyCollection {
    
    var services: [DIAssembly] {
        [RestIOAssembly(),
         MovieDetailsServiceAssembly()]
    }
}
