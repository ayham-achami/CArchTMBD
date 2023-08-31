//
//  PackegeStarter.swift

import CArch
import CArchSwinject

public protocol PackegeStarter<Factory> {
    
    associatedtype Factory: AnyDIAssemblyFactory
    
    var factroy: Factory { get }
    
    init(_ factory: Factory)
}

open class LayoutPackegeStarter: PackegeStarter {
    
    public var factroy: LayoutAssemblyFactory
    
    public required init(_ factory: Factory) {
        self.factroy = factory
    }
}

public protocol FactoryProvider {
    
    var factroy: LayoutAssemblyFactory { get }
}

public final class PackegeStarterBuilder<Factory> where Factory: AnyDIAssemblyFactory {
    
    public static func with(factory: Factory.Type) -> Self {
        .init(factory)
    }
    
    private let factory: Factory
    
    private init(_ factory: Factory.Type) {
        self.factory = factory.init()
    }
    
    public func build<Starter>(starter:  Starter.Type) -> Starter where Starter: PackegeStarter, Starter.Factory == Factory {
        .init(factory)
    }
}
