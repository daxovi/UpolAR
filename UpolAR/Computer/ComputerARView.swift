//
//  ComputerARView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 24.06.2023.
//

import SwiftUI
import ARKit
import RealityKit
import AVFoundation

struct ComputerARView: UIViewRepresentable {
    typealias UIViewType = ARView
    
    let computers: [ComputerModel] = [
        ComputerModel(screenWidth: 0.1, screenHeight: 0.056009, anchorName: "computer_bigbuckbunny", videoName: "computer_bigbuckbunny")
    ]
    
    // MARK: make
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        for computer in computers { arView.scene.addAnchor(computer.getModel()) }
        arView.session.delegate = context.coordinator
        context.coordinator.arView = arView
        context.coordinator.computers = computers
        return arView
    }
    
    // MARK: update
    func updateUIView(_ uiView: ARView, context: Context) {     }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    // MARK: coordinator
    class Coordinator: NSObject, ARSessionDelegate {
        weak var arView: ARView?
        var computers: [ComputerModel]?
        var isARViewActive: Bool?
        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            guard let arView = arView else { return }
            if let computers = computers {
                for computer in computers {
                    if let anchor = arView.scene.findEntity(named: "\(computer.anchorName)Anchor") as? AnchorEntity,
                       let model = arView.scene.findEntity(named: "\(computer.videoName)Screen") as? ModelEntity,
                       let videoMaterial = model.model?.materials.first as? VideoMaterial {
                        if anchor.isAnchored {
                            videoMaterial.avPlayer?.play()
                        } else {
                            videoMaterial.avPlayer?.pause()
                        }
                    }
                }
            }
        }
    }
}
