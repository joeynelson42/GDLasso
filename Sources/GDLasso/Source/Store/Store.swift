//
// ==----------------------------------------------------------------------== //
//
//  Store.swift
//
//  This was originally part of the Lasso open source project.
//
//  To see the original, unmodified source file see: https://github.com/ww-tech/lasso.
//
// ==----------------------------------------------------------------------== //
//

import Foundation

public protocol AbstractStore: AbstractNodeStore, OutputObservable, ExternalActionDispatchable { }

public protocol ConcreteStore: AbstractStore {
    init(with initialState: State)
}

open class GDLassoStore<Module: SceneModule>: ConcreteStore {
    public typealias State = Module.State
    public typealias InternalAction = Module.InternalAction
    public typealias ExternalAction = Module.ExternalAction
    public typealias Output = Module.Output
    
    private let binder: ValueBinder<State>
    
    private var outputBridge = OutputBridge<Output>()
    private var pendingUpdates: [Update<State>] = []
    private let queue = DispatchQueue(label: "lasso-store-sync-queue", target: .global())

    public required init(with initialState: State) {
        self.binder = ValueBinder(initialState)
    }
    
    // state
    public var state: State {
        return binder.value
    }
    
    public func observeState(handler: @escaping (State?, State) -> Void) {
        binder.bind(to: handler)
    }
    
    public func observeState(handler: @escaping (State) -> Void) {
        observeState { _, newState in handler(newState) }
    }
    
    public func observeState<Value>(_ keyPath: WritableKeyPath<State, Value>, handler: @escaping (Value?, Value) -> Void) {
        binder.bind(keyPath, to: handler)
    }
    
    public func observeState<Value>(_ keyPath: WritableKeyPath<State, Value>, handler: @escaping (Value) -> Void) {
        observeState(keyPath) { _, newValue in handler(newValue) }
    }
    
    public func observeState<Value>(_ keyPath: WritableKeyPath<State, Value>, handler: @escaping (Value?, Value) -> Void) where Value: Equatable {
        binder.bind(keyPath, to: handler)
    }
    
    public func observeState<Value>(_ keyPath: WritableKeyPath<State, Value>, handler: @escaping (Value) -> Void) where Value: Equatable {
        observeState(keyPath) { _, newValue in handler(newValue) }
    }
    
    // actions
    public func dispatchInternalAction(_ internalAction: InternalAction) {
        executeOnMainThread { [weak self] in
            self?.handleAction(internalAction)
        }
    }
    
    open func handleAction(_ internalAction: InternalAction) {
        return lassoAbstractMethod()
    }
    
    public func dispatchExternalAction(_ externalAction: ExternalAction) {
        executeOnMainThread { [weak self] in
            self?.handleAction(externalAction)
        }
    }
    
    open func handleAction(_ externalAction: ExternalAction) {
        return lassoAbstractMethod()
    }
    
    // outputs
    public func observeOutput(_ observer: @escaping (Output) -> Void) {
        outputBridge.register(observer)
    }
    
    public func dispatchOutput(_ output: Output) {
        outputBridge.dispatch(output)
    }
    
    // updates
    
    public typealias Update<T> = (inout T) -> Void
    
    public func update(_ update: @escaping Update<State> = { _ in return }) {
        updateState(using: update, apply: true)
    }
    
    public func batchUpdate(_ update: @escaping Update<State>) {
        updateState(using: update, apply: false)
    }

    private func updateState(using update: @escaping Update<State>, apply: Bool) {
        var newState: State?
        var pendingUpdates: [Update<State>]?
        queue.sync {
            self.pendingUpdates.append(update)
            if apply {
                pendingUpdates = self.pendingUpdates
                self.pendingUpdates = []
            }
        }
        if let pendingUpdates = pendingUpdates {
            newState = pendingUpdates.reduce(into: state) { state, update in
                update(&state)
            }
        }
        if let newState = newState {
            binder.set(newState)
        }
    }
    
}

extension GDLassoStore where State: Equatable {
    
    public func observeState(handler: @escaping (State?, State) -> Void) {
        binder.bind(to: handler)
    }
    
    public func observeState(handler: @escaping (State) -> Void) {
        observeState { _, newState in handler(newState) }
    }
    
}

extension GDLassoStore where Module.State == EmptyState {
    
    public convenience init() {
        self.init(with: EmptyState())
    }
    
}

/// Public-access, type-erased Store
/// - receives actions
/// - readable, observable state
/// - receives outputs, observable outputs
public class AnyStore<State, InternalAction, ExternalAction, Output>: AnyNodeStore<State, InternalAction>, AbstractStore {
    
    internal init<Store: AbstractStore>(_ store: Store) where Store.State == State, Store.InternalAction == InternalAction, Store.Output == Output {
        self._observeOutput = store.observeOutput
        super.init(store, stateMap: { $0 }, actionMap: { $0 })
    }
    
    public func observeOutput(_ observer: @escaping (Output) -> Void) {
        _observeOutput(observer)
    }
    
    private let _observeOutput: (@escaping (Output) -> Void) -> Void
    
    public func dispatchExternalAction(_ externalAction: ExternalAction) {}
    
}

extension AbstractStore {
    
    public func asAnyStore() -> AnyStore<State, InternalAction, NoAction, Output> {
        return AnyStore<State, InternalAction, NoAction, Output>(self)
    }
    
}
