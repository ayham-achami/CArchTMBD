//
//  ServicesAssembly.swift

import CArch
import Foundation
import CArchSwinject

struct MoviesServices: DIAssemblyCollection {
    
    var services: [DIAssembly] {
        [MoviesServiceAssembly()]
    }
}

struct MovieDetailsServices: DIAssemblyCollection {
    
    var services: [DIAssembly] {
        [MovieDetailsServiceAssembly()]
    }
}

