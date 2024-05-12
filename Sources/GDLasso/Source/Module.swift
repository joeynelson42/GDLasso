//
// ==----------------------------------------------------------------------== //
//
//  Module.swift
//
//  This was originally part of the Lasso open source project.
//
//  To see the original, unmodified source file see: https://github.com/ww-tech/lasso.
//
// ==----------------------------------------------------------------------== //
//

/// A `SceneModule` is used to define the set of types involved in creating a store.
///
/// All communication follows a unidirectional data flow:
/// - `Action`s are typically sent from a view controller to the `Store`.
/// - The `Store` updates it's `State`.
/// - `State` changes are received by setting up observations on the `Store`.
///
/// The `Store` may also emit `Output`.
public protocol SceneModule {
    
    /// `Action` defines the actions that can be dispatched to the `Store` from the Node.
    associatedtype InternalAction = NoAction
    
    /// `Action` defines the actions that can be dispatched to the `Store` from without the Node context.
    associatedtype ExternalAction = NoAction
    
    /// `State` defines the set of properties the `Store` manages.
    associatedtype State = EmptyState
    
    /// `Output` defines the set of signals the `Store` can generate.
    associatedtype Output = NoOutput
    
    /// The primary, type-erased, public access `Store` for the module.
    typealias Store = AnyStore<State, InternalAction, ExternalAction, Output>
    
    /// The `ViewStore` is a type-erased lens into the `Store`, that hides the `Output`.
    /// The `ViewStore` is typically used as the interface the view controller sees.
    typealias NodeStore = AnyNodeStore<State, InternalAction>
    
}

/// A `NodeModule` is used when creating a set of types the view layer (i.e. a Node) cares about.
///
/// A NodeModule:
/// 1) 'Erases' the Output from an AbstractStore. The resulting abstraction is more appropriate for use by
///    the view layer, which should NEVER observe Outputs.
/// 2) Provides an opportunity to transform state into a form that can be more directly digested by the view layer.
///    It is thus possible to define all state mappings in a context outside of the view layer, maximizing the amount
///    of testable business logic. In this fashion, it is possible to extract all business logic from the view layer.
public protocol NodeModule {
    
    /// Typically maps to the InternalAction of `SceneModule`.
    associatedtype NodeAction = NoAction
    associatedtype NodeState = EmptyState
    
    typealias NodeStore = AnyNodeStore<NodeState, NodeAction>
}
