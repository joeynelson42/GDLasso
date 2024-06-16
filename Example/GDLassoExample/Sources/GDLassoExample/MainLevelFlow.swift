//
//  MainLevelFlow.swift
//
//
//  Created by Joey Nelson on 5/11/24.
//

import Foundation
import SwiftGodot
import GDLasso

struct MainLevelFlowModule: FlowModule {

    static var rootNodePath: String = "res://main.tscn"
    
}

class MainLevelFlow: SceneFlow<MainLevelFlowModule> {
    
    
    
}

@Godot
class MainLevel: Node3D {
    @SceneTree(path: "PlayerController") var playerController: PlayerController?
    @SceneTree(path: "EnvironmentController") var environmentController: EnvironmentController?
    
    private var playerStore = PlayerStore(with: .init())
    private var environmentStore = EnvironmentStore(with: .init())
    
    override func _ready() {
        if var playerController {
            playerController.set(store: playerStore.asNodeStore())
        }
        
        if var environmentController {
            environmentController.set(store: environmentStore.asNodeStore())
            environmentStore.observeOutput(handleEnvironmentOutput(_:))
        }
    }
    
    private func handleEnvironmentOutput(_ output: GDLassoStore<EnvironmentModule>.Output) {
        switch output {
        case .damageCausedToEntity(let entity, let damage):
            if let playerController, playerController == entity {
                playerStore.dispatchExternalAction(.damageCausedToPlayer(amount: damage))
            }
        }
    }
}
