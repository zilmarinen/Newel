//
//  Slope.swift
//  Newel
//
//  Created by Zack Brown on 14/04/2026.
//

import Deltille

public enum Slope: String,
                   CaseIterable,
                   Codable,
                   Identifiable,
                   Sendable {
    
    case corner
    case narrow
    case wide
    
    public var id: String { rawValue.capitalized }
    
    public var coordinates: [Coordinate] {
        
        tiles.map {
            
            $0.triangle.vertex.position
        }
    }
    
    internal var tiles: [Tile] {
        
        switch self {
            
        case .corner:
            
            [.init(triangle: .init(-1, 1, 0),
                   rotation: .clockwise,
                   rise: .ascending),
             .init(triangle: .init(-1, 0, 0),
                    rotation: .clockwise,
                    rise: .descending),
             .init(triangle: .zero,
                    rotation: .counterClockwise,
                    rise: .descending),
             .init(triangle: .init(0, 0, -1),
                    rotation: .counterClockwise,
                    rise: .ascending)]
            
        case .narrow:
            
            [.init(triangle: .init(-1, 0, 0),
                   rotation: .counterClockwise,
                   rise: .ascending),
             .init(triangle: .zero,
                    rotation: .counterClockwise,
                    rise: .descending),
             .init(triangle: .init(0, 0, -1),
                    rotation: .counterClockwise,
                    rise: .ascending)]
            
        case .wide:
            
            [.init(triangle: .init(-1, 0, 1),
                   rotation: .counterClockwise,
                   rise: .descending),
             .init(triangle: .init(-1, 0, 0),
                    rotation: .counterClockwise,
                    rise: .ascending),
             .init(triangle: .zero,
                    rotation: .counterClockwise,
                    rise: .descending),
             .init(triangle: .init(0, 0, -1),
                    rotation: .counterClockwise,
                    rise: .ascending),
             .init(triangle: .init(1, 0, -1),
                    rotation: .counterClockwise,
                    rise: .descending)]
        }
    }
}
