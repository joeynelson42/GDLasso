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
    @SceneTree(path: "EnvironmentController") var environmentController: EnvironmentController?
    
    private var playerStore = PlayerStore(with: .init())
    private var environmentStore = EnvironmentStore(with: .init())
    
    override func _ready() {
        if var playerController {
            playerController.set(store: playerStore.asNodeStore())
            GD.print("Set PlayerController store.")
        }
        
        if var environmentController {
            environmentController.set(store: environmentStore.asNodeStore())
            GD.print("Set EnvironmentController store.")
        }
    }
}
