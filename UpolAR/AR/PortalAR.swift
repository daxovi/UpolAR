//
//  PortalAR.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 04.03.2022.
//

import Foundation
import SwiftUI
import RealityKit
import ARKit

struct PortalAR: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let innerSpaceSize: Float = 3.0 // [meters]
        let innerSpaceMargin: Float = 0.02 // [meters]
        let innerSpaceOcclusion: Float = 0.01 // [meters] for to create a door inside the inner space

        let arView = ARView(frame: .zero)

        // load one of bundled rcprojects as an inner space
        let portalAnchor = try! PortalARUmbrellas.loadScene()   // Portal 1: Umbrellas

        arView.scene.anchors.append(portalAnchor)

        // make an occlusion box that surrounds the inner space.
        let boxSize: Float = innerSpaceSize + innerSpaceMargin
        let boxMesh = MeshResource.generateBox(size: boxSize)
        let material = OcclusionMaterial()
        let occlusionBox = ModelEntity(mesh: boxMesh, materials: [material])
        occlusionBox.position.y = boxSize / 2
        occlusionBox.position.z = -(innerSpaceMargin + innerSpaceOcclusion) // make door using occlusion
        portalAnchor.addChild(occlusionBox)

        // start the AR session.
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        arView.session.run(config)

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
    }
}
