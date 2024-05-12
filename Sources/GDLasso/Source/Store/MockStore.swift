//
// ==----------------------------------------------------------------------== //
//
//  MockStore.swift
//
//  This was originally part of the Lasso open source project.
//
//  To see the original, unmodified source file see: https://github.com/ww-tech/lasso.
//
// ==----------------------------------------------------------------------== //
//

import Foundation

public final class MockGDLassoStore<Module: SceneModule>: ConcreteStore {
    public typealias State = Module.State
    public typealias InternalAction = Module.InternalAction
    public typealias ExternalAction = Module.ExternalAction
    public typealias Output = Module.Output
    
    public var dispatchedActions = [InternalAction]()
    
    private let binder: ValueBinder<State>
    
    private var outputBridge = OutputBridge<Output>()
    
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
    public func dispatchAction(_ internalAction: Module.InternalAction) {
        dispatchedActions.append(internalAction)
    }
    
    // outputs
    public func observeOutput(_ observer: @escaping (Output) -> Void) {
        outputBridge.register(observer)
    }
    
    public func dispatchMockOutput(_ output: Output) {
        outputBridge.dispatch(output)
    }
    
    // updates
    
    public typealias Update<T> = (inout T) -> Void
    
    public func mockUpdate(_ update: @escaping Update<State> = { _ in return }) {
        var newState = state
        update(&newState)
        binder.set(newState)
    }

}
