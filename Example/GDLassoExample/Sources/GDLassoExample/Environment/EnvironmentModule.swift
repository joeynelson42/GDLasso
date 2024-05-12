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
    }
    
    enum InternalAction {
        case entityEnteredDangerZone(entity: Node3D)
        case entityExitedDangerZone(entity: Node3D)
    }
    
    enum ExternalAction {
        
    }
    
    enum Output {
        case damageCausedToEntity(entity: Object, damage: Int)
    }
    
}
