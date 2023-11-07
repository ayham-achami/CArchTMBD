//
//  PreviewFactory.swift
//

#if DEBUG
import CArch
import CArchSwinject
import Foundation
import TMDBCore

extension WelcomeModule {
    
    /// Объект содержащий логику создания модуля `Welcome`
    /// с чистой иерархии (просто ViewController)
    final class PreviewBuilder: ClearHierarchyModuleBuilder {
        
        typealias InitialStateType = WelcomeModuleState.InitialStateType
        
        private let builder: Builder
        
        init() {
            LayoutAssemblyFactory.registerAppComponents()
            builder = .init(.init())
        }

        func build(with initialState: InitialStateType) -> CArchModule {
            let module = build()
            module.initializer?.set(initialState: initialState)
            return module
        }
        
        func build() -> CArchModule {
            builder.build()
        }
    }
}

extension MainModule {
    
    /// Объект содержащий логику создания модуля `Main`
    /// с чистой иерархии (просто ViewController)
    final class PreviewBuilder: ClearHierarchyModuleBuilder {
        
        typealias InitialStateType = MainModuleState.InitialStateType
        
        private let builder: Builder
        
        init() {
            LayoutAssemblyFactory.registerAppComponents()
            builder = .init(.init())
        }

        func build(with initialState: InitialStateType) -> CArchModule {
            let module = build()
            module.initializer?.set(initialState: initialState)
            return module
        }
        
        func build() -> CArchModule {
            builder.build()
        }
    }
}
#endif
