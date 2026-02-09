//
//  AppViewModel.swift
//  Newel Viewer
//
//  Created by Zack Brown on 15/11/2025.
//

import Alluvium
import Combine
import Deltille
import Euclid
import Foundation
import Lattice
import Newel
import SceneKit
import SwiftUI

@MainActor
internal class AppViewModel: ObservableObject {
    
    @Published internal var staircaseType: StaircaseType = .small {
        
        didSet {
            
            guard oldValue != staircaseType else { return }
            
            updateScene()
        }
    }
    
    @Published internal var direction: StaircaseType.Direction = .ascending {
        
        didSet {
            
            guard oldValue != direction else { return }
            
            updateScene()
        }
    }
    
    internal let scene = SCNScene()
    
    internal let gridColor: NSColor = .grid
    internal let gridAlternateColor: NSColor = .gridAlternate
    
    internal let model = SCNNode()
    internal let wireframe = SCNNode()
    internal let surface = SCNNode()
    
    internal init() {
        
        updateScene()
        
        scene.rootNode.addChildNode(model)
        scene.rootNode.addChildNode(surface)
        
        model.addChildNode(wireframe)
    }
}

extension AppViewModel {
    
    private func updateScene() {
        
        updateModel()
        
        updateSurface()
    }
    
    private func updateModel() {
        
        let mesh = Mesh.staircase(staircaseType,
                                  7,
                                  Triangle.Scale.tile.edgeLength / 2.0,
                                  direction)
        
        model.geometry = .init(mesh)
        wireframe.geometry = .init(wireframe: mesh)
    }
    
    private func updateSurface() {
        
        var mesh = Mesh([])
        
        for tile in staircaseType.footprint.perimeter {
            
            let color = tile.isPointy ? gridColor : gridAlternateColor
            
            mesh = mesh.merge(tile.mesh(.tile,
                                        .init(color)))
        }
        
        surface.geometry = .init(mesh)
    }
}
