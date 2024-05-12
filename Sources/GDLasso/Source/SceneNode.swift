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
    
    var store: NodeStore { get }
    
    func set(store: NodeStore)
}

extension SceneNode {
    
    public var state: NodeState {
        return store.state
    }
    
    public func dispatchAction(_ action: NodeAction) {
        store.dispatchAction(action)
    }
    
}
