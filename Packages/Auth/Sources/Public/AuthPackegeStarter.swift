//
//  AuthPackegeStarter.swift

import CArch
import TMDBCore
import Foundation
import CArchSwinject

public final class AuthPackegeStarter: LayoutPackegeStarter {
    
    public func login() -> CArchModule {
        LoginModule.Builder(factroy).build()
    }
}
