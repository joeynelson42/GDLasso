//
// ==----------------------------------------------------------------------== //
//
//  OutputBridge.swift
//
//  This was originally part of the Lasso open source project.
//
//  To see the original, unmodified source file see: https://github.com/ww-tech/lasso.
//
// ==----------------------------------------------------------------------== //
//

import Foundation

internal final class OutputBridge<Output> {
    
    public init() {
    }
    
    internal func register(_ handler: @escaping (Output) -> Void) {
        outputObservers.append(handler)
    }
    
    internal func dispatch(_ output: Output) {
        executeOnMainThread { [weak self] in
            self?.outputObservers.forEach { $0(output) }
        }
    }
    
    private var outputObservers: [(Output) -> Void] = []
}
