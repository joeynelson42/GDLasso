//
// ==----------------------------------------------------------------------== //
//
//  NodeStore.swift
//
//  This was originally part of the Lasso open source project.
//
//  To see the original, unmodified source file see: https://github.com/ww-tech/lasso.
//
// ==----------------------------------------------------------------------== //
//

import Foundation
#if canImport(Combine)
import Combine
#endif

public protocol AbstractNodeStore: StateObservable, InternalActionDispatchable { }

/// Public-access, type-erased View Store
/// - receives actions
/// - readable, observable state
public class AnyNodeStore<NodeState, NodeAction>: AbstractNodeStore {

    /// Create a `NodeStore`
    ///
    /// - Parameters:
    ///   - store: the concrete, source store
    ///   - stateMap: pure function; maps store state to view state
    ///   - actionMap: pure function; maps view action to store action
    internal init<Store: AbstractNodeStore>(
        _ store: Store,
        stateMap: @escaping (Store.State) -> NodeState,
        actionMap: @escaping (NodeAction) -> Store.InternalAction
    ) {
        self.binder = ValueBinder<NodeState>(stateMap(store.state))
        
        self._dispatchInternalAction = { NodeAction in
            store.dispatchInternalAction(actionMap(NodeAction))
        }
        
        store.observeState { [weak self] (_, newState) in
            self?.binder.set(stateMap(newState))
        }
    }
    
    /// Create a `NodeStore` where the `NodeAction` is `NoAction`.
    ///
    /// - Parameters:
    ///   - store: the concrete, source store
    ///   - stateMap: pure function; maps store state to view state
    internal init<Store: AbstractNodeStore>(
        _ store: Store,
        stateMap: @escaping (Store.State) -> NodeState
    ) where NodeAction == NoAction {
        self.binder = ValueBinder<NodeState>(stateMap(store.state))
        
        self._dispatchInternalAction = { _ in }
        
        store.observeState { [weak self] (_, newState) in
            self?.binder.set(stateMap(newState))
        }
    }
    
    #if canImport(Combine)
    /// `objectWillChange` publisher, if available and needed.
    private var _objectWillChange: Any?
    #endif
    
    public func dispatchInternalAction(_ NodeAction: NodeAction) {
        _dispatchInternalAction(NodeAction)
    }
    
    public var state: NodeState {
        return binder.value
    }
    
    public func observeState(handler: @escaping (NodeState?, NodeState) -> Void) {
        binder.bind(to: handler)
    }
    
    public func observeState(handler: @escaping (NodeState) -> Void) {
        observeState { _, newState in handler(newState) }
    }
    
    public func observeState<Value>(_ keyPath: WritableKeyPath<NodeState, Value>, handler: @escaping (Value?, Value) -> Void) {
        binder.bind(keyPath, to: handler)
    }
    
    public func observeState<Value>(_ keyPath: WritableKeyPath<NodeState, Value>, handler: @escaping (Value) -> Void) {
        observeState(keyPath) { _, newValue in handler(newValue) }
    }
    
    public func observeState<Value>(_ keyPath: WritableKeyPath<NodeState, Value>, handler: @escaping (Value?, Value) -> Void) where Value: Equatable {
        binder.bind(keyPath, to: handler)
    }
    
    public func observeState<Value>(_ keyPath: WritableKeyPath<NodeState, Value>, handler: @escaping (Value) -> Void) where Value: Equatable {
        observeState(keyPath) { _, newValue in handler(newValue) }
    }
    
    private let binder: ValueBinder<NodeState>
    private let _dispatchInternalAction: (NodeAction) -> Void
}

extension AnyNodeStore where NodeState: Equatable {
    
    public func observeState(handler: @escaping (NodeState?, NodeState) -> Void) {
        binder.bind(to: handler)
    }
    
    public func observeState(handler: @escaping (NodeState) -> Void) {
        observeState { _, newState in handler(newState) }
    }
    
}

extension AbstractNodeStore {
    
    public typealias ActionMap<A> = (A) -> InternalAction
    public typealias StateMap<S> = (State) -> S
    
    /// Create a NodeStore with a NodeState that can be initialized from the Store's State,
    /// using a NodeModule to define the relevant NodeState & NodeAction types.
    ///
    /// - Parameters:
    ///   - NodeModuleType: the NodeModule that defines the target NodeState
    ///   - stateMap: a closure that converts the Store's State to the NodeState
    /// - Returns: a new NodeStore
    public func asNodeStore<Module: NodeModule>(
        for NodeModuleType: Module.Type,
        stateMap: @escaping StateMap<Module.NodeState>
    ) -> AnyNodeStore<Module.NodeState, Module.NodeAction> where Module.NodeAction == InternalAction {
        asNodeStore(stateMap: stateMap, actionMap: { $0 })
    }
    
    /// Create a `NodeStore` with a `NodeState` that can be initialized from the Store's State,
    /// using a `NodeModule` whose `NodeAction` is `NoAction` to define the relevant `NodeState` type.
    ///
    /// - Parameters:
    ///   - NodeModuleType: the NodeModule that defines the target NodeState
    ///   - stateMap: a closure that converts the Store's State to the NodeState
    /// - Returns: a new NodeStore
    public func asNodeStore<Module: NodeModule>(
        for NodeModuleType: Module.Type,
        stateMap: @escaping StateMap<Module.NodeState>
    ) -> AnyNodeStore<Module.NodeState, NoAction> where Module.NodeAction == NoAction {
        AnyNodeStore<Module.NodeState, NoAction>(self, stateMap: stateMap)
    }
    
    /// Create a `NodeStore` using a subset of actions, with the Store's `State` type,
    /// using a `NodeModule` to define the relevant `NodeState` & `NodeAction` types.
    ///
    /// - Parameters:
    ///   - NodeModuleType: the NodeModule that defines the target NodeAction
    ///   - actionMap: a closure that maps the View's actions to the Store's actions
    /// - Returns: a new NodeStore
    public func asNodeStore<Module: NodeModule>(
        for NodeModuleType: Module.Type,
        actionMap: @escaping ActionMap<Module.NodeAction>
    ) -> AnyNodeStore<Module.NodeState, Module.NodeAction> where Module.NodeState == State {
        asNodeStore(stateMap: { $0 }, actionMap: actionMap)
    }
    
    /// Create a `NodeStore` using a subset of actions,
    /// with a `NodeState` that can be initialized from the Store's `State`,
    /// using a `NodeModule` to define the relevant `NodeState` & `NodeAction` types.
    ///
    /// - Parameters:
    ///   - NodeModuleType: the NodeModule that defines the target NodeState and NodeAction
    ///   - stateMap: a closure that converts the Store's State to the NodeState
    ///   - actionMap: a closure that maps the View's actions to the Store's actions
    /// - Returns: a new NodeStore
    public func asNodeStore<Module: NodeModule>(
        for NodeModuleType: Module.Type,
        stateMap: @escaping StateMap<Module.NodeState>,
        actionMap: @escaping ActionMap<Module.NodeAction>
    ) -> AnyNodeStore<Module.NodeState, Module.NodeAction> {
        asNodeStore(stateMap: stateMap, actionMap: actionMap)
    }
    
    /// Create a `NodeStore` using the Store's `State` and `Action` types,
    /// that provides access to just the `dispatchInternalAction` and `observeState` methods.
    ///
    /// - Returns: a new NodeStore
    public func asNodeStore() -> AnyNodeStore<State, InternalAction> {
        asNodeStore(stateMap: { $0 }, actionMap: { $0 })
    }
    
    /// Create a `NodeStore` with a `NodeState` that can be initialized from the Store's `State`.
    ///
    /// - Parameter stateMap: a closure that maps the View's actions to the Store's actions
    /// - Returns: a new NodeStore
    public func asNodeStore<NodeState>(
        stateMap: @escaping StateMap<NodeState>
    ) -> AnyNodeStore<NodeState, InternalAction> {
        asNodeStore(stateMap: stateMap, actionMap: { $0 })
    }
    
    /// Create a `NodeStore` using a subset of actions, with the Store's `State` type.
    ///
    /// - Parameter actionMap: a closure that maps the View's actions to the Store's actions
    /// - Returns: a new NodeStore
    public func asNodeStore<NodeAction>(
        actionMap: @escaping ActionMap<NodeAction>
    ) -> AnyNodeStore<State, NodeAction> {
        asNodeStore(stateMap: { $0 }, actionMap: actionMap)
    }
    
    /// Create a `NodeStore` using a subset of actions,
    /// with a `NodeState` that can be initialized from the Store's `State`.
    ///
    /// - Parameters:
    ///   - actionMap: a closure that maps the View's actions to the Store's actions
    ///   - stateMap: a closure that converts the Store's State to the NodeState
    /// - Returns: a new NodeStore
    public func asNodeStore<NodeState, NodeAction>(
        stateMap: @escaping StateMap<NodeState>,
        actionMap: @escaping ActionMap<NodeAction>
    ) -> AnyNodeStore<NodeState, NodeAction> {
        AnyNodeStore<NodeState, NodeAction>(self, stateMap: stateMap, actionMap: actionMap)
    }
    
}

#if canImport(Combine)
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension AnyNodeStore: ObservableObject {
    
    public typealias StateChangePublisher = PassthroughSubject<NodeState, Never>
    
    public var objectWillChange: StateChangePublisher {
        if let willChange = _objectWillChange as? StateChangePublisher {
            return willChange
        }
        
        let willChange = StateChangePublisher()
        observeState { [weak self] state in
            (self?._objectWillChange as? StateChangePublisher)?.send(state)
        }
        _objectWillChange = willChange
        return willChange
    }
    
}
#endif
