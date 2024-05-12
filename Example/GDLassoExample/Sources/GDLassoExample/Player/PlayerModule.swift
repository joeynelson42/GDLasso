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
        var isDead: Bool = false
    }
    
    enum InternalAction {
        case didCollideWithCollider(KinematicCollision3D)
    }
    
    enum ExternalAction {
        
    }
    
    enum Output {
        
    }
}