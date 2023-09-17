//
//  AppAssembly.swift
//  TMDB

import CArch
import Foundation
import CArchSwinject

struct AppAssembly: ServicesRecorder {
    
    var records: [any DIAssemblyCollection] {
        [CoreDICollection(),
         NavigatorsDICollection()]
    }
}
