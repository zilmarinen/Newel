//
//  StaircaseType.swift
//  Newel
//
//  Created by Zack Brown on 16/11/2025.
//

import Deltille
import Euclid
import Lattice

public enum StaircaseType: String,
                           CaseIterable,
                           Codable,
                           Identifiable,
                           Sendable {
    
    public enum Direction: String,
                           CaseIterable,
                           Identifiable,
                           Sendable {
        
        case ascending
        case descending
        
        public var id: String { rawValue.capitalized }
    }
    
    case small
    case large
    
    public var id: String { rawValue.capitalized }
    
    public var footprint: Triangle.Footprint { .init(Triangle.zero, tiles) }
    
    internal var tiles: [Triangle] {
        
        switch self {
            
        case .small: [.init(-1, 0, 0),
                      Triangle.zero,
                      .init(0, 0, -1)]
            
        case .large: [.init(-1, 0, 1),
                      .init(-1, 0, 0),
                      Triangle.zero,
                      .init(0, 0, -1),
                      .init(1, 0, -1)]
        }
    }
    
    internal var corners: (v0: Vector,
                           v1: Vector,
                           v2: Vector,
                           v3: Vector)? {
        
        guard let lhs = tiles.first,
              let rhs = tiles.last,
              let lhe = edges.first,
              let rhe = edges.last,
              let lhc0 = lhe.corners.first,
              let lhc1 = lhe.corners.last,
              let rhc0 = rhe.corners.first,
              let rhc1 = rhe.corners.last else { return nil }
        
        return (lhs.vertex(lhc0).position(.tile),
                lhs.vertex(lhc1).position(.tile),
                rhs.vertex(rhc0).position(.tile),
                rhs.vertex(rhc1).position(.tile))
    }
    
    internal var edges: [Triangle.Edge] {
        
        guard let lhs = tiles.first,
              let rhs = tiles.last else { return [] }
        
        switch self {
            
        case .small:
            
            guard let lhe = lhs.edges.last,
                  let rhe = rhs.edges.first else { return [] }
            
            return [lhe,
                    rhe]
            
        case .large:
            
            guard let lhe = lhs.edges.first,
                  let rhe = rhs.edges.last else { return [] }
            
            return [lhe,
                    rhe]
        }
    }
    
    public func template(displacement: Double) -> Mesh {
        
        var mesh = Mesh.empty
        
        for tile in tiles {
            
            let volume = Volume(vertices: tile.vertices.position(.tile),
                                displacement: displacement)
            
            mesh = mesh.union(volume.mesh(.white))
        }
        
        return mesh
    }
}
