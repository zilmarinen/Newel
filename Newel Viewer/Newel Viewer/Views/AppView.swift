//
//  AppView.swift
//  Newel Viewer
//
//  Created by Zack Brown on 15/11/2025.
//

import Deltille
import Lattice
import Newel
import SceneKit
import SwiftUI

struct AppView: View {
    
    @ObservedObject private var viewModel = AppViewModel()
    
    var body: some View {
            
        #if os(iOS)
            NavigationStack {
        
                viewer
            }
        #else
            viewer
        #endif
    }
    
    var viewer: some View {
        
        ZStack(alignment: .bottomTrailing) {
            
            sceneView
        }
    }
    
    var sceneView: some View {
        
        SceneView(scene: viewModel.scene,
                  options: [.allowsCameraControl,
                            .autoenablesDefaultLighting])
        .toolbar {
            
            ToolbarItemGroup {
                
                toolbar
            }
        }
        .navigationTitle("Verdure")
    }
    
    @ViewBuilder
    var toolbar: some View {
        
        Picker("Stoop",
               selection: $viewModel.stoop) {
            
            ForEach(Stoop.allCases, id: \.self) { stoop in
                
                Text(stoop.id)
                    .id(stoop)
            }
        }
        
        Picker("Direction",
               selection: $viewModel.direction) {
            
            ForEach(Stoop.Direction.allCases, id: \.self) { direction in
                
                Text(direction.id)
                    .id(direction)
            }
        }
    }
}
