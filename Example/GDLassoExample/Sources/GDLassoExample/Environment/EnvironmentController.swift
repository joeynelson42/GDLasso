//
//  EnvironmentController.swift
//
//
//  Created by Joey Nelson on 5/12/24.
//

import Foundation
import GDLasso
import SwiftGodot

@Godot
class EnvironmentController: Node3D, SceneNode {

    @SceneTree(path: "DangerZone/DangerZoneArea3D") var dangerZoneArea: Area3D?
    
    var store: EnvironmentModule.NodeStore?
    
    func setUpObservations() {
        initializeAreaMonitoring()
    }
    
    private func initializeAreaMonitoring() {
        GD.print("initializeAreaMonitoring attempting...")
        guard let dangerZoneArea else { return }
        
        dangerZoneArea.bodyEntered.connect { [weak self] body in
            guard let self else { return }
            store?.dispatchAction(.entityEnteredDangerZone(entity: body))
        }
        
        dangerZoneArea.bodyExited.connect { [weak self] body in
            guard let self else { return }
            store?.dispatchAction(.entityExitedDangerZone(entity: body))
        }
        
        GD.print("initializeAreaMonitoring success")
    }
}
