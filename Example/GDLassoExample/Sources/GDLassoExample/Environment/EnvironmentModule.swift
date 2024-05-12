//
//  EnvironmentModule.swift
//
//
//  Created by Joey Nelson on 5/12/24.
//

import Foundation
import GDLasso
import SwiftGodot

struct EnvironmentModule: SceneModule {
    
    struct State {
        var entitiesInDangerZone: [Node3D] = []
        
        var dangerZoneDamage: Int = 10
    }
    
    enum InternalAction {
        case entityEnteredDangerZone(entity: Node3D)
        case entityExitedDangerZone(entity: Node3D)
    }
    
    enum ExternalAction {
        
    }
    
    enum Output {
        case damageCausedToEntity(entity: Node3D, damage: Int)
    }
    
}
