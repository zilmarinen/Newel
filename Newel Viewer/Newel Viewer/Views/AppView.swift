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
        .navigationTitle("Newel")
    }
    
    @ViewBuilder
    var toolbar: some View {
        
        Picker("StaircaseType",
               selection: $viewModel.staircaseType) {
            
            ForEach(StaircaseType.allCases, id: \.self) { staircaseType in
                
                Text(staircaseType.id)
                    .id(staircaseType)
            }
        }
        
        Picker("Direction",
               selection: $viewModel.direction) {
            
            ForEach(StaircaseType.Direction.allCases, id: \.self) { direction in
                
                Text(direction.id)
                    .id(direction)
            }
        }
    }
}
