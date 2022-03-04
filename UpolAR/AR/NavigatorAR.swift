//
//  NavigatorAR.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 04.03.2022.
//

import Foundation
import RealityKit
import SwiftUI


struct NavigatorAR: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! NavigatorARScene.loadBox()
        let bytAnchor = try! NavigatorARScene.loadByt()
        
        // zkouska occlusionmaterial na schovani boxu
        // let material = SimpleMaterial(color: .red, isMetallic: false)
        let material = OcclusionMaterial(receivesDynamicLighting: true)
        
        let boxMesh = MeshResource.generateBox(width: 0.022, height: 0.024, depth: 0.2)
        let occlusionBox = ModelEntity(mesh: boxMesh, materials: [material])
        occlusionBox.position.x = -0.083
        occlusionBox.position.y = 0.01
        occlusionBox.collision?.filter = CollisionFilter(group: .all, mask: .all)
        bytAnchor.addChild(occlusionBox)
            
        // Add the box anchor to the scene
        arView.scene.anchors.append(boxAnchor)
        arView.scene.anchors.append(bytAnchor)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}
