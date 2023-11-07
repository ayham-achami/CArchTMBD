//
//  NavigatorsDICollection.swift
//

import CArch
import Foundation

struct NavigatorsDICollection: DIAssemblyCollection {
    
    var services: [DIAssembly] {
        [AuthNavigatorAssembly(),
         MoviesNavigatorAssembly()]
    }
}
