//
// ==----------------------------------------------------------------------== //
//
//  SceneNode.swift
//
// ==----------------------------------------------------------------------== //
//

import Foundation

public protocol SceneNode {
    
    associatedtype NodeState
    
    associatedtype NodeAction
    
    typealias NodeStore = AnyNodeStore<NodeState, NodeAction>
    
    var store: NodeStore? { get set }
    
    func set(store: NodeStore)
    
    func setUpObservations()
    
}

extension SceneNode {
    
    public mutating func set(store: NodeStore) {
        self.store = store
        setUpObservations()
    }
    
    public func setUpObservations() {}
    
    public var state: NodeState? {
        return store?.state
    }
    
    public func dispatchAction(_ action: NodeAction) {
        store?.dispatchAction(action)
    }
    
}
