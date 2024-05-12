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
    
    typealias Store = PlayerStore
    
    var store: Store? {
        didSet {
            setUpObservations()
        }
    }
    
    var speed: Float = 10
    
    var targetVelocity = Vector3.zero
    
    override func _physicsProcess(delta: Double) {
        var direction = Input.getVector(negativeX: "move_left", positiveX: "move_right", negativeY: "move_down", positiveY: "move_up")
        
        if direction != .zero {
            direction = direction.normalized()
        }
        
        targetVelocity.x = direction.x * speed
        targetVelocity.z = direction.y * speed
        
        velocity = targetVelocity
        let collision = moveAndCollide(motion: velocity * delta)
        
        if let collision {
            store?.dispatchAction(.didCollideWithCollider(collision))
        }
    }
    
    private func setUpObservations() {
        guard let store else { return }
        
        store.observeState(\.isDead) { isDead in
            if isDead {
                GD.print("player died")
            }
        }
    }
}
