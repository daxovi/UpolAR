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
    
    // MARK: make
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        let anchor = AnchorEntity(.image(group: "AR Resources", name: "photo_anchor"))
        anchor.name = "photo_anchor"
        
        let box = ModelEntity(mesh: .generateBox(size: simd_make_float3(0.595, 0.001, 0.325)))
        box.name = "videoBox"
        
        loadVideoMaterial(video: "compas", model: box)
        
        arView.session.delegate = context.coordinator
        context.coordinator.arView = arView
        
        anchor.addChild(box)
        arView.scene.anchors.append(anchor)
        
        return arView
    }
    
    func loadVideoMaterial(video: String, model: ModelEntity) {
        guard let pathToVideo = Bundle.main.path(forResource: video, ofType: "mp4") else { return }
        
        let videoURL = URL(fileURLWithPath: pathToVideo)
        let avPlayer = AVPlayer(url: videoURL)
        // 16:9 video
        let material = VideoMaterial(avPlayer: avPlayer)
        model.model?.materials = [material]
        
        avPlayer.volume = 0.05
        // avPlayer.play()
    }
    
    // MARK: update
    func updateUIView(_ uiView: ARView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, ARSessionDelegate {
        weak var arView: ARView?
                
        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            guard let arView = arView else { return }
            
            if let anchor = arView.scene.findEntity(named: "photo_anchor") as? AnchorEntity {
                if anchor.isAnchored {
                    print("DEBUG: photo is anchored")
                    
                    guard let model = arView.scene.findEntity(named: "videoBox") as? ModelEntity else { return }
                            
                    if let videoMaterial = model.model?.materials.first as? VideoMaterial {
                        videoMaterial.avPlayer?.seek(to: .zero)
                        videoMaterial.avPlayer?.play()
                        print("DEBUG: play")
                    }
                }
            }
            
            
        }
    }
}


