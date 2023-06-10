//
//  NavigatorARView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 10.06.2023.
//

import SwiftUI
import RealityKit

struct NavigatorARView: UIViewRepresentable {
    typealias UIViewType = ARView
    
    // MARK: make
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        let anchor = AnchorEntity(.image(group: "AR Resources", name: "arrow"))

        let box = ModelEntity(mesh: .generateBox(size: simd_make_float3(0.1, 0.03, 0.05)))
        
        anchor.addChild(box)
        arView.scene.addAnchor(anchor)
        
        let anchor2 = AnchorEntity(.image(group: "AR Resources", name: "o1"))

        let box2 = ModelEntity(mesh: .generateBox(size: simd_make_float3(0.03, 0.01, 0.05)))
        
        anchor2.addChild(box2)
        arView.scene.addAnchor(anchor2)
        
        return arView
    }
    
    // MARK: update
    func updateUIView(_ uiView: ARView, context: Context) {

    }
}

