//
//  ServicesAssembly.swift

import Foundation

import CArch
import Foundation
import CArchSwinject

struct PreviewsServices: DIAssemblyCollection {
    
    var services: [DIAssembly] {
        [PreviewsServiceAssembly()]
    }
}

