//
//  Rise.swift
//  Newel
//
//  Created by Zack Brown on 14/04/2026.
//

public enum Rise: String,
                  CaseIterable,
                  Codable,
                  Identifiable,
                  Sendable {
    
    internal static let elevation = 0.6
    
    case ascending
    case descending
    
    public var id: String { rawValue.capitalized }
    
    public var ascending: Bool { self == .ascending }
    
    public var inverse: Self { self == .ascending ? .descending : .ascending }
}
