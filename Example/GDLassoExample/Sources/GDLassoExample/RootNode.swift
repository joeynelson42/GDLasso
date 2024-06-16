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
    
    private var mainFlow: MainLevelFlow?
    
    override func _ready() {
        mainFlow = MainLevelFlow()
        
    }
    
}
