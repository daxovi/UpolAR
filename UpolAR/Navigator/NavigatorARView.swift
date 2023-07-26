//
//  NavigatorARView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 24.06.2023.
//

import SwiftUI
import ARKit
import RealityKit

struct NavigatorARView: UIViewRepresentable {
    typealias UIViewType = ARView
    
    // MARK: make
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        let stairsAnchor = try! Navigator.loadArrowStairs()
        arView.scene.addAnchor(stairsAnchor)
        
        let rightAnchor = try! Navigator.loadArrowRight()
        arView.scene.addAnchor(rightAnchor)
        
        let upAnchor = try! Navigator.loadArrowUp()
        arView.scene.addAnchor(upAnchor)
        
        return arView
    }
    
    // MARK: update
    func updateUIView(_ uiView: ARView, context: Context) {    }
}
