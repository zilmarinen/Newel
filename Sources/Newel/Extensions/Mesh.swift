//
//  Mesh.swift
//  Newel
//
//  Created by Zack Brown on 15/11/2025.
//

import Bivouac
import Deltille
import Euclid

extension Mesh {
    
    public static func slope(_ slope: Slope,
                             _ rise: Rise,
                             _ cast: Cast,
                             _ color: Color) -> Self {
        
        var mesh = Mesh.empty
        
        for tile in slope.tiles {
            
            let stencil = tile.triangle.stencil(.tile)
            
            let tileRise = rise == .ascending ? tile.rise : tile.rise.inverse
            
            let part = switch cast {
            
            case .sloped:
                
                Self.slope(tileRise,
                           stencil,
                           color)
                
            case .terraced:
                
                Self.terrace(tileRise,
                             stencil,
                             color)
            }
            
            guard tile.rotation != .identity else {
                
                mesh = mesh.union(part)
                
                continue
            }
            
            let offset = tile.triangle.vertex.position(.tile)
            let angle = Angle(radians: tile.rotation.radians)
            let rotation = Rotation.yaw(angle)
            
            let transformed = part.translated(by: -offset).rotated(by: rotation).translated(by: offset)
            
            mesh = mesh.union(transformed)
        }
        
        return mesh
    }
    
    private static func slope(_ rise: Rise,
                              _ stencil: Triangle.Stencil,
                              _ color: Color) -> Self {
        
        let elevation = Vector(0.0, Rise.elevation, 0.0)
        
        let v0 = stencil.v0 + (!rise.ascending ? elevation : .zero)
        let v1 = stencil.v1 + (rise.ascending ? elevation : .zero)
        let v2 = stencil.v2 + (rise.ascending ? elevation : .zero)
        
        var faces = [[stencil.v2, stencil.v1, stencil.v0],
                     [v0, v1, v2]]
        
        switch rise {
            
        case .ascending:
            
            faces.append([stencil.v0, stencil.v1, v1])
            faces.append([stencil.v2, stencil.v0, v2])
            faces.append([stencil.v1, stencil.v2, v2, v1])
            
        case .descending:
            
            faces.append([stencil.v0, stencil.v1, v0])
            faces.append([stencil.v2, stencil.v0, v0])
        }
        
        let surfaces = faces.compactMap {
            
            Polygon.surface($0,
                            color)
        }
        
        return Mesh(surfaces)
    }
    
    private static func terrace(_ rise: Rise,
                                _ stencil: Triangle.Stencil,
                                _ color: Color) -> Self {
        
        let steps = [[stencil.v0, stencil.v3, stencil.v4],
                     [stencil.v3, stencil.v5, stencil.v7, stencil.v4],
                     [stencil.v5, stencil.v8, stencil.v11, stencil.v7],
                     [stencil.v8, stencil.v1, stencil.v2, stencil.v11]]
        
        let stepHeight = Rise.elevation / Double(steps.count)
        
        var mesh = Mesh.empty
        
        for i in steps.indices {
            
            let step = steps[i]
            
            let height = rise.ascending ? stepHeight * Double(i + 1) : Rise.elevation - (stepHeight * Double(i))
            
            let elevation = Vector(0.0, height, 0.0)
            
            var faces = [step.map { $0 + elevation },
                         step.reversed()]
            
            for j in step.indices {
                
                let k = (j + 1) % step.count
                
                let v0 = step[j]
                let v1 = step[k]
                let v2 = v1 + elevation
                let v3 = v0 + elevation
                
                faces.append([v0, v1, v2, v3])
            }
            
            let surfaces = faces.compactMap {
                
                Polygon.surface($0,
                                color)
            }
            
            mesh = mesh.union(Mesh(surfaces))
        }
        
        return mesh
    }
}
