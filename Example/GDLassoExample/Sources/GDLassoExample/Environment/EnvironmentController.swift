//
//  EnvironmentController.swift
//
//
//  Created by Joey Nelson on 5/12/24.
//

import Foundation
import GDLasso
import SwiftGodot

@Godot
class EnvironmentController: Node3D, SceneNode {
    
    var store: EnvironmentModule.NodeStore?
    
    func set(store: EnvironmentModule.NodeStore) {
        self.store = store
    }
    
    
}
