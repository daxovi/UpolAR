//
//  LensARView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 17.06.2023.
//

import SwiftUI
import ARKit
import RealityKit

struct LensARView: UIViewRepresentable {
    typealias UIViewType = ARView
    
    // MARK: make
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        let config = ARFaceTrackingConfiguration()
        arView.session.run(config)
        
        let logoAnchor = try! Lens.loadLogo()
        arView.scene.addAnchor(logoAnchor)
        
        let ahojAnchor = try! Lens.loadAhoj()
        arView.scene.addAnchor(ahojAnchor)
        
        return arView
        
    }
    
    // MARK: update
    func updateUIView(_ uiView: ARView, context: Context) {

    }
}

