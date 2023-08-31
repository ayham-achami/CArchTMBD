//
//  PreviewFactory.swift
//  TMDB


#if DEBUG
import CArch
import TMDBCore
import Foundation
import CArchSwinject

private let factory: LayoutAssemblyFactory = .init()

extension WelcomeModule {
    
    /// Объект содержащий логику создания модуля `Welcome`
    /// с чистой иерархии (просто ViewController)
    final class PreviewBuilder: ClearHierarchyModuleBuilder {
        
        typealias InitialStateType = WelcomeModuleState.InitialStateType
        
        private let buidler: Builder
        
        init() {
            factory.record(CoreDICollection())
            factory.record(NovigatorsDICollection())
            buidler = .init(factory)
        }

        func build(with initialState: InitialStateType) -> CArchModule {
            let module = build()
            module.initializer?.set(initialState: initialState)
            return module
        }
        
        func build() -> CArchModule {
            buidler.build()
        }
    }
}

extension MainModule {
    
    /// Объект содержащий логику создания модуля `Main`
    /// с чистой иерархии (просто ViewController)
    final class PreviewBuilder: ClearHierarchyModuleBuilder {
        
        typealias InitialStateType = MainModuleState.InitialStateType
        
        private let buidler: Builder
        
        init() {
            factory.record(CoreDICollection())
            factory.record(NovigatorsDICollection())
            buidler = .init(factory)
        }

        func build(with initialState: InitialStateType) -> CArchModule {
            let module = build()
            module.initializer?.set(initialState: initialState)
            return module
        }
        
        func build() -> CArchModule {
            buidler.build()
        }
    }
}
#endif
