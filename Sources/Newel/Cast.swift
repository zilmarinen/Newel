//
//  Cast.swift
//  Newel
//
//  Created by Zack Brown on 14/04/2026.
//

public enum Cast: String,
                  CaseIterable,
                  Codable,
                  Identifiable,
                  Sendable {
    
    case sloped
    case terraced
    
    public var id: String { rawValue.capitalized }
}
