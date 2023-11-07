//
//  PackageStarter.swift
//

import CArch
import CArchSwinject

public final class PackageStarterBuilder<Factory> where Factory: AnyDIAssemblyFactory {
    
    public static func with(factory: Factory.Type) -> Self {
        .init(factory)
    }
    
    private let factory: Factory
    
    private init(_ factory: Factory.Type) {
        self.factory = factory.init()
    }
    
    public func build<Starter>(starter: Starter.Type) -> Starter where Starter: PackageStarter, Starter.Factory == Factory {
        .init(factory)
    }
}

open class LayoutPackageStarter: PackageStarter {
    
    public var factory: LayoutAssemblyFactory
    
    public required init(_ factory: Factory) {
        self.factory = factory
    }
}

public protocol FactoryProvider {
    
    var factory: LayoutAssemblyFactory { get }
}

public protocol PackageStarter<Factory> {
    
    associatedtype Factory: AnyDIAssemblyFactory
    
    var factory: Factory { get }
    
    init(_ factory: Factory)
}
