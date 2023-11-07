//
//  ServicesAssembly.swift
//

import CArch
import CArchSwinject
import Foundation

struct LoginServices: DIAssemblyCollection {
    
    var services: [DIAssembly] {
        [AuthServiceAssembly()]
    }
}
