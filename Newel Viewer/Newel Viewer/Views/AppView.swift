//
//  AppView.swift
//  Newel Viewer
//
//  Created by Zack Brown on 15/11/2025.
//

import Bivouac
import Deltille
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
        
        Picker("Slope",
               selection: $viewModel.slope) {
            
            ForEach(Slope.allCases, id: \.self) { slope in
                
                Text(slope.id)
                    .id(slope)
            }
        }
        
        Picker("Rise",
               selection: $viewModel.rise) {
            
            ForEach(Rise.allCases, id: \.self) { rise in
                
                Text(rise.id)
                    .id(rise)
            }
        }
        
        Picker("Cast",
               selection: $viewModel.cast) {
            
            ForEach(Cast.allCases, id: \.self) { cast in
                
                Text(cast.id)
                    .id(cast)
            }
        }
    }
}
