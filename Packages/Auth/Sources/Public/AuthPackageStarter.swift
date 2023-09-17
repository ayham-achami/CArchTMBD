//
//  AuthPackageStarter.swift

import CArch
import TMDBCore
import Foundation
import CArchSwinject

public final class AuthPackageStarter: LayoutPackageStarter {
    
    public func login() -> CArchModule {
        LoginModule.Builder(factory).build()
    }
}
