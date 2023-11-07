//
//  ServicesAssembly.swift
//

import CArch
import CArchSwinject
import Foundation

struct PreviewsServices: DIAssemblyCollection {
    
    var services: [DIAssembly] {
        [PreviewsServiceAssembly()]
    }
}
