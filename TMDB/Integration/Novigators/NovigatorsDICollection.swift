//
//  NovigatorsDICollection.swift
//  TMDB

import CArch
import Foundation

struct NovigatorsDICollection: DIAssemblyCollection {
    
    var services: [DIAssembly] {
        [AuthNavigatorAssembly(),
         MoviesNavigatorAssembly()]
    }
}
