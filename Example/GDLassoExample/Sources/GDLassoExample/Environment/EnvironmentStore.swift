//
//  EnvironmentStore.swift
//
//
//  Created by Joey Nelson on 5/12/24.
//

import Foundation
import SwiftGodot
import GDLasso

class EnvironmentStore: GDLassoStore<EnvironmentModule> {
    
    override func handleAction(_ internalaAction: GDLassoStore<EnvironmentModule>.InternalAction) {
        switch internalaAction {
        case .entityEnteredDangerZone(let entity):
            GD.print("entity entered danger zone")
//            update { $0.entitiesInDangerZone.append(entity) }
            
        case .entityExitedDangerZone(let entity):
            GD.print("entity exited danger zone")
//            if let index = state.entitiesInDangerZone.firstIndex(of: entity) {
//                var updatedEntities = state.entitiesInDangerZone
//                updatedEntities.remove(at: index)
//                update { $0.entitiesInDangerZone = updatedEntities }
//            }
        }
    }
    
    override func handleAction(_ externalAction: GDLassoStore<EnvironmentModule>.ExternalAction) {}
}
