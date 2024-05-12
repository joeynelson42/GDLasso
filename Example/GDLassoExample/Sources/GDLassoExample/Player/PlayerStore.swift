//
//  PlayerStore.swift
//
//
//  Created by Joey Nelson on 5/11/24.
//

import Foundation
import GDLasso
import SwiftGodot

class PlayerStore: GDLassoStore<PlayerModule> {
    
    override func handleAction(_ internalaAction: GDLassoStore<PlayerModule>.InternalAction) {
        switch internalaAction {
        case .didCollideWithCollider(let collision):
            GD.print("Player collided with collider at position: \(collision.getPosition())")
        }
    }
    
    override func handleAction(_ externalAction: GDLassoStore<PlayerModule>.ExternalAction) {
        
    }
    
}
