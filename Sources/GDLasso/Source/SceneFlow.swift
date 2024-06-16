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
    
    associatedtype RequiredContext: Node
    
}

open class SceneFlow<Module: FlowModule> {
    
    public private(set) weak var context: RequiredContext?
    public private(set) weak var rootNode: Node?
    
    public typealias Output = Module.Output
    public typealias RequiredContext = Module.RequiredContext
    
    private let outputBridge = OutputBridge<Output>()
    
    /// Starts the flow by creating the initial node and adding it to the tree
    public func start(with context: RequiredContext) {
        let rootNode = createRootNode()
        self.context = context
        self.rootNode = rootNode
        
        context.addChild(node: rootNode)
    }
    
    /// Creates the initial node for the Flow.
    ///
    /// Do not call this directly, instead use the `start` function.
    open func createRootNode() -> Node {
        return lassoAbstractMethod()
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
