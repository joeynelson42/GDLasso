//
//  PlayerStore.swift
//
//
//  Created by Joey Nelson on 5/11/24.
//

import Foundation
import GDLasso

class PlayerStore: GDLassoStore<PlayerModule> {
    
    override func handleAction(_ internalaAction: GDLassoStore<PlayerModule>.InternalAction) {
        switch internalaAction {
        case .didCollideWithCollider(let collision):
            break
        }
    }
    
    override func handleAction(_ externalAction: GDLassoStore<PlayerModule>.ExternalAction) {
        
    }
    
}
