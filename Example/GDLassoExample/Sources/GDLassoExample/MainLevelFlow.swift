//
//  MainLevelFlow.swift
//
//
//  Created by Joey Nelson on 5/11/24.
//

import Foundation
import SwiftGodot
import GDLasso

@Godot
class MainLevelFlow: Node3D, SceneFlow {
    @SceneTree(path: "PlayerController") var playerController: PlayerController?
    
    private var playerStore = PlayerStore(with: .init(isDead: false))
    
    override func _ready() {
        GD.print("Main Flow ready")
        
        if let playerController {
            GD.print("Setting player controller store")
            playerController.store = playerStore
        }
    }
}
