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

    typealias RootNode = MainLevel
    
    static var rootNodePath: String = "res://main.tscn"
    
}

class MainLevelFlow: SceneFlow<MainLevelFlowModule> {
    
    private var playerStore = PlayerStore(with: .init())
    private var environmentStore = EnvironmentStore(with: .init())
    
    override func initializeRootNode(_ root: MainLevel) {
        // Setup environmentController
        root.environmentController?.set(store: environmentStore.asNodeStore())
        environmentStore.observeOutput(handleEnvironmentOutput(_:))
        
        // Setup playerController
        root.playerController?.set(store: playerStore.asNodeStore())
    }
    
    private func handleEnvironmentOutput(_ output: GDLassoStore<EnvironmentModule>.Output) {
        switch output {
        case .damageCausedToEntity(let entity, let damage):
            if let controller = rootNode?.playerController, controller == entity {
                playerStore.dispatchExternalAction(.damageCausedToPlayer(amount: damage))
            }
        }
    }
}
