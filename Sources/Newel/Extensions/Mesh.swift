//
//  Mesh.swift
//  Newel
//
//  Created by Zack Brown on 15/11/2025.
//

import Euclid

extension Mesh {
    
    public static func staircase(_ stoop: Stoop,
                                 _ steps: Int,
                                 _ height: Double,
                                 _ direction: Stoop.Direction) -> Self {
        
        guard let (v0, v1, v2, v3) = stoop.corners else { return .empty }
        
        let rise = 1.0 / Double(steps)
        
        var faces: [[Vector]] = []
        
        faces.append([v0, v1, v2, v3])
        
        switch direction {
            
        case .ascending:
            
            faces.append([v2,
                          v1,
                          v1 + .init(0.0, height, 0.0),
                          v2 + .init(0.0, height, 0.0)])
            
        case .descending:
            
            faces.append([v0,
                          v3,
                          v3 + .init(0.0, height, 0.0),
                          v0 + .init(0.0, height, 0.0)])
        }
        
        for step in 0..<steps {
            
            let i = rise * Double(step)
            let j = rise * Double(step + 1)
            
            let iStep = direction == .ascending ? i : 1.0 - i
            let jStep = direction == .ascending ? j : 1.0 - j
            
            let elevationStart = Vector(0.0, (height * iStep), 0.0)
            let elevationEnd = Vector(0.0, (height * jStep), 0.0)
            
            let v4 = v0.lerp(v1, i)
            let v5 = v0.lerp(v1, j)
            let v6 = v3.lerp(v2, i)
            let v7 = v3.lerp(v2, j)
            
            //lhs
            faces.append([v5,
                          v4,
                          v4 + elevationEnd,
                          v5 + elevationEnd])
            
            //rhs
            faces.append([v6,
                          v7,
                          v7 + elevationEnd,
                          v6 + elevationEnd])
            
            //front
            
            faces.append([v4 + elevationEnd,
                          v4 + elevationStart,
                          v6 + elevationStart,
                          v6 + elevationEnd])
            
            //tread
            
            faces.append([v5 + elevationEnd,
                          v4 + elevationEnd,
                          v6 + elevationEnd,
                          v7 + elevationEnd])
        }
        
        let polygons = faces.compactMap {
            
            Polygon($0)
        }
        
        return Mesh(polygons)
    }
}
