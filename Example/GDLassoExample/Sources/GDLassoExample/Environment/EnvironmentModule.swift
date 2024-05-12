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
        var entitiesInDangerZone: [Object] = []
    }
    
    enum InternalAction {
        case entityEnteredDangerZone(entity: Object)
        case entityExitedDangerZone(entity: Object)
    }
    
    enum ExternalAction {
        
    }
    
    enum Output {
        case damageCausedToEntity(entity: Object, damage: Int)
    }
    
}
