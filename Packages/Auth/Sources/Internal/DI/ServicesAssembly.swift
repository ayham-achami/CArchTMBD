//
//  ServicesAssembly.swift

import CArch
import Foundation
import CArchSwinject

struct LoginServices: DIAssemblyCollection {
    
    var services: [DIAssembly] {
        [AuthServiceAssembly()]
    }
}
