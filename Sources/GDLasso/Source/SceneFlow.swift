//
// ==----------------------------------------------------------------------== //
//
//  SceneFlow.swift
//
// ==----------------------------------------------------------------------== //
//

import Foundation

/// A FlowModule describes the types that can be used in a flow.
/// FlowModules have Output, and can specify what kind of view controller they are placed in.
public protocol FlowModule {
    
    associatedtype Output = NoOutput
    
    associatedtype RequiredContext: AnyObject //: UIViewController = UIViewController
    
}

open class SceneFlow<Module: FlowModule> {
    
    public private(set) weak var context: RequiredContext?
    //    public private(set) weak var initialController: UIViewController?
    
    public typealias Output = Module.Output
    public typealias RequiredContext = Module.RequiredContext
    
    private let outputBridge = OutputBridge<Output>()
    
    /// Starts the flow
    ///
    /// Places the controller returned by 'createInitialController' with the provided placer.
    /// Handles ARC considerations relative to the Flow, creating a strong reference from
    /// the initial controller to the Flow.
    ///
    /// - Parameter placer: ScreenPlacer with 'placedContext' that is compatible with the Flow's 'RequiredContext'
    public func start(with context: RequiredContext) {
//        lassoPrecondition(placer != nil, "\(self).start(with: placer) placer is nil!")
//        guard let placer = placer else { return }
//        
//        let initialController = createInitialController()
//        
//        initialController.holdReference(to: self)
//        
//        self.context = initialController.place(with: placer)
//        self.initialController = initialController
    }
    
    /// Creates the initial view controller for the Flow.
    ///
    /// Do not call this directly, instead use the `start` function.
//    open func createInitialController() -> UIViewController {
//        return lassoAbstractMethod()
//    }
    
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
