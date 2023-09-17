//
//  ServicesAssembly.swift

import CArch
import TMDBCore
import Foundation
import CArchSwinject

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

struct PersonServices: DIAssemblyCollection {
    
    var services: [DIAssembly] {
        [RestIOAssembly(),
         PersonServiceAssembly()]
    }
}
