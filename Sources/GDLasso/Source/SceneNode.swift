//
// ==----------------------------------------------------------------------== //
//
//  SceneNode.swift
//
// ==----------------------------------------------------------------------== //
//

import Foundation

public protocol SceneNode: AnyObject {
    
    associatedtype NodeState
    
    associatedtype NodeAction
    
    typealias NodeStore = AnyNodeStore<NodeState, NodeAction>
    
    var store: NodeStore? { get set }
    
    func set(store: NodeStore)
    
    func setUp(with store: NodeStore)
    
}

extension SceneNode {
    
    public func set(store: NodeStore) {
        self.store = store
        setUp(with: store)
    }
    
    public func setUp(with store: NodeStore) {}
    
    public var state: NodeState? {
        return store?.state
    }
    
    public func dispatchInternalAction(_ action: NodeAction) {
        store?.dispatchInternalAction(action)
    }
    
}
