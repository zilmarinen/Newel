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
import SceneKit
import SwiftUI

@MainActor
internal class AppViewModel: ObservableObject {
    
    internal let footprint: Footprint = .init(Triangle.zero,
                                              [Triangle.zero,
                                               .init(-1, 0, 0),
                                               .init(0, 0, -1)])
    
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
        
        let mesh = Mesh.empty
        
        model.geometry = .init(mesh)
        wireframe.geometry = .init(wireframe: mesh)
    }
    
    private func updateSurface() {
        
        var mesh = Mesh([])
        
        for tile in footprint.perimeter {
            
            let color: NSColor = tile.isPointy ? gridColor : gridAlternateColor
            
            mesh = mesh.merge(tile.mesh(.tile,
                                        .init(color)))
        }
        
        surface.geometry = .init(mesh)
    }
}
