//
//  MainLevel.swift
//  
//
//  Created by Joey Nelson on 6/16/24.
//

import Foundation
import SwiftGodot

@Godot
class MainLevel: Node3D {
    @SceneTree(path: "PlayerController") var playerController: PlayerController?
    @SceneTree(path: "EnvironmentController") var environmentController: EnvironmentController?
}

