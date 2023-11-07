//
//  AuthPackageStarter.swift
//

import CArch
import CArchSwinject
import Foundation
import TMDBCore

public final class AuthPackageStarter: LayoutPackageStarter {
    
    public func login() -> CArchModule {
        LoginModule.Builder(factory).build()
    }
}
