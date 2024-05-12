//
//  PlayerModule.swift
//  
//
//  Created by Joey Nelson on 5/11/24.
//

import Foundation
import GDLasso
import SwiftGodot

struct PlayerModule: SceneModule {
    
    struct State {
        var health: Int = 100
        var isDead: Bool { return health <= 0 }
    }
    
    enum InternalAction {
        case didCollideWithCollider(KinematicCollision3D)
    }
    
    enum ExternalAction {
        case damageCausedToPlayer(amount: Int)
    }
    
    enum Output {
        
    }
}
