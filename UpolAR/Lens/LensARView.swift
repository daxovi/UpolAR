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
        let glassAnchor = try! Lens.loadGlass()
        arView.scene.addAnchor(glassAnchor)
        return arView
    }
    
    // MARK: update
    func updateUIView(_ uiView: ARView, context: Context) {    }
}

