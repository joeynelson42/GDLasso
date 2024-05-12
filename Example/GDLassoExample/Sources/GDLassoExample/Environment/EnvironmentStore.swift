//
//  EnvironmentStore.swift
//
//
//  Created by Joey Nelson on 5/12/24.
//

import Foundation
import SwiftGodot
import GDLasso
import Combine

class EnvironmentStore: GDLassoStore<EnvironmentModule> {
    
    private var damageTimerCancellable: Cancellable?
    
    required init(with initialState: GDLassoStore<EnvironmentModule>.State) {
        super.init(with: initialState)
        setUpDamageTimer()
    }
    
    deinit {
        damageTimerCancellable?.cancel()
    }
    
    private func setUpDamageTimer() {
        damageTimerCancellable = Foundation.Timer.publish(every: 1.0, on: .main, in: .default).autoconnect().sink(receiveValue: { [weak self] _ in
            guard let self else { return }
            for entity in state.entitiesInDangerZone {
                dispatchOutput(.damageCausedToEntity(entity: entity, damage: state.dangerZoneDamage))
            }
        })
    }
    
    override func handleAction(_ internalaAction: GDLassoStore<EnvironmentModule>.InternalAction) {
        switch internalaAction {
        case .entityEnteredDangerZone(let entity):
            GD.print("entity entered danger zone")
            update { $0.entitiesInDangerZone.append(entity) }
            
        case .entityExitedDangerZone(let entity):
            GD.print("entity exited danger zone")
            if let index = state.entitiesInDangerZone.firstIndex(of: entity) {
                var updatedEntities = state.entitiesInDangerZone
                updatedEntities.remove(at: index)
                update { $0.entitiesInDangerZone = updatedEntities }
            }
        }
    }
    
    override func handleAction(_ externalAction: GDLassoStore<EnvironmentModule>.ExternalAction) {}
}
