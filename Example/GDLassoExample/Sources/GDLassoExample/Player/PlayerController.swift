//
//  PlayerController.swift
//
//
//  Created by Joey Nelson on 5/11/24.
//

import Foundation
import SwiftGodot
import GDLasso

@Godot
class PlayerController: CharacterBody3D, SceneNode {
    
    var store: PlayerModule.NodeStore?
    
    var speed: Float = 10
    
    var targetVelocity = Vector3.zero
    
    override func _physicsProcess(delta: Double) {
        var direction = Input.getVector(negativeX: "move_right", positiveX: "move_left", negativeY: "move_down", positiveY: "move_up")
        
        if direction != .zero {
            direction = direction.normalized()
        }
        
        targetVelocity.x = direction.x * speed
        targetVelocity.z = direction.y * speed
        
        velocity = targetVelocity
        let collision = moveAndCollide(motion: velocity * delta)
        
        if let collision {
            dispatchAction(.didCollideWithCollider(collision))
        }
    }
    
    func setUpObservations() {
        guard let store else { return }
        
        store.observeState(\.isDead) { isDead in
            if isDead {
                GD.print("player died")
            }
        }
    }
}
