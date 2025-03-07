//
// ==----------------------------------------------------------------------== //
//
//  SceneFlow.swift
//
// ==----------------------------------------------------------------------== //
//

import Foundation
import SwiftGodot

/// A FlowModule describes the types that can be used in a flow.
/// FlowModules have Output, and can specify what kind of view controller they are placed in.
public protocol FlowModule {
    
    associatedtype Output = NoOutput
    
}

open class SceneFlow<Module: FlowModule, RootNode: Node> {
    
    public private(set) weak var rootNode: RootNode?
    
    public var rootNodePath: String { "" }
    
    public typealias Output = Module.Output
    
    private let outputBridge = OutputBridge<Output>()
    
    public init() { }
    
    /// Starts the flow by creating the initial node and adding it to the tree
    public func start(with context: Node) {
        let root = createRootNode()
        rootNode = root
        initializeRootNode(root)
        context.addChild(node: root)
    }
    
    open func initializeRootNode(_ root: RootNode) { }
    
    /// Creates the initial node for the Flow.
    private func createRootNode() -> RootNode {
        guard let packed = GD.load(path: rootNodePath) as? PackedScene,
              let rootNode = packed.instantiate() as? RootNode
        else { fatalError("Failed to create Flow's root node.") }
        
        return rootNode
    }
    
    @discardableResult
    public func observeOutput(_ handler: @escaping (Output) -> Void) -> Self {
        outputBridge.register(handler)
        return self
    }
    
    // Convenience for simple mapping from the Screen's Output type to another OtherOutput type
    //  - so callers don't have to create a closure do perform simple mapping.
    @discardableResult
    public func observeOutput<OtherOutput>(_ handler: @escaping (OtherOutput) -> Void, mapping: @escaping (Output) -> OtherOutput) -> Self {
        observeOutput { output in
            handler(mapping(output))
        }
        return self
    }
    
    public func dispatchOutput(_ output: Output) {
        outputBridge.dispatch(output)
    }
}
