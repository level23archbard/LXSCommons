//
//  Container.swift
//  LXSCommons
//
//  Created by Alex Rote on 3/1/20.
//

public class Container<Element> {
    
    private var contents: Box<Element>
    private var observations = Box([Observation]())
    
    public init(_ contents: Element) {
        self.contents = Box(contents)
    }
    
    public func property<T>(_ keyPath: KeyPath<Element, T>) -> Property<T> {
        let contents = self.contents
        return Property(base: keyPath) {
            contents.value[keyPath: keyPath]
        }
    }
    
    public func mutableProperty<T>(_ keyPath: WritableKeyPath<Element, T>) -> MutableProperty<T> {
        let contents = self.contents
        weak var observations = self.observations
        return MutableProperty(base: keyPath, reader: {
            contents.value[keyPath: keyPath]
        }, writer: { newValue in
            contents.value[keyPath: keyPath] = newValue
            observations?.value.filter { $0.p == keyPath }.forEach { $0.block() }
        })
    }
    
    private struct Observation {
        let o: Observer
        let p: AnyKeyPath
        let block: ()->()
    }
    
    public class Observer {}
    
    public func observe<T>(using observer: Observer? = nil, property: Property<T>, block: @escaping ()->()) -> Observer {
        let observer = observer ?? Observer()
        let observation = Observation(o: observer, p: property.base, block: block)
        observations.value.append(observation)
        return observer
    }
    
    public func removeObserver(_ observer: Observer) {
        observations.value.removeAll { $0.o === observer }
    }
}

public class Property<T> {
    
    fileprivate let base: AnyKeyPath
    private let reader: ()->(T)
    
    fileprivate init(base: AnyKeyPath, reader: @escaping ()->(T)) {
        self.base = base
        self.reader = reader
    }
    
    public var value: T {
        get {
            return reader()
        }
    }
}

public class MutableProperty<T>: Property<T> {
    
    private let writer: (T)->()
    
    fileprivate init(base: AnyKeyPath, reader: @escaping ()->(T), writer: @escaping (T)->()) {
        self.writer = writer
        super.init(base: base, reader: reader)
    }
    
    public override var value: T {
        get {
            super.value
        }
        set {
            writer(newValue)
        }
    }
}
