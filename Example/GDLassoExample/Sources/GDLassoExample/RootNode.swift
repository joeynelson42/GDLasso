//
//  RootNode.swift
//
//
//  Created by Joey Nelson on 6/16/24.
//

import Foundation
import SwiftGodot

@Godot
final class RootNode: Node {
    
    private let mainFlowPath = "res://main.tscn"
    
    override func _ready() {
        guard let packed = GD.load(path: mainFlowPath) as? PackedScene,
              let mainFlow = packed.instantiate() as? Node3D
        else { return }
        
        addChild(node: mainFlow)
    }
    
}
