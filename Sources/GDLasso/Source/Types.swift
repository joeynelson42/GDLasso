//
// ==----------------------------------------------------------------------== //
//
//  Types.swift
//
//  This was originally part of the Lasso open source project.
//
//  To see the original, unmodified source file see: https://github.com/ww-tech/lasso.
//
// ==----------------------------------------------------------------------== //
//

import Foundation

#if swift(>=4.2)
#else
#error("Lasso is only supported for versions of Swift >= 4.2")
#endif

public enum NoAction: Equatable { }
public enum NoOutput: Equatable { }

public struct EmptyState: Equatable {
    public init() { }
}

// meta

/// These kinds of types have a `state` value, which is:
/// - gettable
/// - observable
public protocol StateObservable: AnyObject {
    associatedtype State
    
    var state: State { get }
    
    /// Get notifications when the `state` value changes.
    ///
    /// - Parameter handler: The closure to be called when `state` changes
    /// - Parameter oldValue: the previous value, `nil` when called for the first time
    /// - Parameter newValue: the new value.
    func observeState(handler: @escaping (_ oldValue: State?, _ newValue: State) -> Void)
    
    /// Get notifications when a `state` property changes.
    ///
    /// - Parameter keyPath: the KeyPath to the property of `state`
    /// - Parameter handler: the closure to be called when the property changes
    /// - Parameter oldValue: the previous value, `nil` when called for the first time
    /// - Parameter newValue: the new value.
    func observeState<Value>(_ keyPath: WritableKeyPath<State, Value>, handler: @escaping (_ oldValue: Value?, _ newValue: Value) -> Void)
}

/// These kinds of types have an `Action` type, which is
/// - an enum
/// - dispatchable
public protocol ExternalActionDispatchable: AnyObject {
    associatedtype ExternalAction
    
    func dispatchExternalAction(_ externalAction: ExternalAction)
}

/// These kinds of types have an `Action` type, which is
/// - an enum
/// - dispatchable
public protocol InternalActionDispatchable: AnyObject {
    associatedtype InternalAction
    
    func dispatchInternalAction(_ internalAction: InternalAction)
}

/// These kinds of types have an `Output` type, which is
/// - an enum
/// - observable
public protocol OutputObservable: AnyObject {
    associatedtype Output
    
    func observeOutput(_ observer: @escaping (Output) -> Void)
}

internal func lassoAbstractMethod<T>(line: UInt = #line, function: String = #function, file: StaticString = #file) -> T {
    fatalError("abstract method \(function) must be overridden by subclass", file: file, line: line)
}

internal func lassoPrecondition(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String = String(), file: StaticString = #file, line: UInt = #line) {
    if !condition() {
        let filename = file.description.components(separatedBy: "/").last(where: { !$0.isEmpty }) ?? ""
        lassoPreconditionFailure("""
            Lasso ERROR: \(message()) (\(filename) line \(line))
                  Add a symbolic breakpoint on lassoPreconditionFailure to catch this in the debugger
            """)
    }
}

private func lassoPreconditionFailure(_ message: String) {
    print(message)
}
