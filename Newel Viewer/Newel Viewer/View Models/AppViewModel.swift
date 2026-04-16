//
//  AppViewModel.swift
//  Newel Viewer
//
//  Created by Zack Brown on 15/11/2025.
//

import Alluvium
import Bivouac
import Combine
import Deltille
import Euclid
import Foundation
import Newel
import SceneKit
import SwiftUI

@MainActor
internal class AppViewModel: ObservableObject {
    
    @Published internal var slope: Slope = .corner {
        
        didSet {
            
            guard oldValue != slope else { return }
            
            updateScene()
        }
    }
    
    @Published internal var rise: Rise = .ascending {
        
        didSet {
            
            guard oldValue != rise else { return }
            
            updateScene()
        }
    }
    
    @Published internal var cast: Cast = .terraced {
        
        didSet {
            
            guard oldValue != cast else { return }
            
            updateScene()
        }
    }
    
    internal let scene = SCNScene()
    
    internal let gridColor: NSColor = .grid
    internal let gridAlternateColor: NSColor = .gridAlternate
    internal let slopeColor: NSColor = .slope
    
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
        
        let mesh = Mesh.slope(slope,
                              rise,
                              cast,
                              .init(slopeColor))
        
        model.geometry = .init(mesh)
        wireframe.geometry = .init(wireframe: mesh)
    }
    
    private func updateSurface() {
        
        var mesh = Mesh([])
        
        let tiles = slope.coordinates.map {
            
            Triangle($0)
        }
        
        let perimeter = Set(tiles.flatMap {
            
            $0.perimeter
        })
        
        for tile in perimeter {
            
            let color = tile.isPointy ? gridColor : gridAlternateColor
            
            guard let surface = Mesh.surface(tile.vertices.position(.tile),
                                                         .init(color)) else { continue }
                        
            mesh = mesh.merge(surface)
        }
        
        surface.geometry = .init(mesh)
    }
}
