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
        ComputerModel(screenWidth: 0.1, screenHeight: 0.0667, anchorName: "systemos", videoName: "systemos"),
        ComputerModel(screenWidth: 0.1, screenHeight: 0.075031, anchorName: "satelite", videoName: "satelite"),
        ComputerModel(screenWidth: 0.1, screenHeight: 0.075, anchorName: "ibook", videoName: "ibook"),
        ComputerModel(screenWidth: 0.1, screenHeight: 0.075031, anchorName: "digital", videoName: "digital")
    ]
    
    // MARK: make
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        for computer in computers {
            arView.scene.addAnchor(loadScreen(computerModel: computer))
        }
        
        arView.session.delegate = context.coordinator
        context.coordinator.arView = arView
        context.coordinator.computers = computers
        
        return arView
    }
    
    func loadScreen(computerModel: ComputerModel) -> AnchorEntity {
        let anchor = AnchorEntity(.image(group: "AR Resources", name: computerModel.anchorName))
        anchor.name = "\(computerModel.anchorName)Anchor"
        
        let box = MeshResource.generateBox(width: computerModel.screenWidth, height: 0.001, depth: computerModel.screenHeight)
        let videoBox = ModelEntity(mesh: box)
        if let videoMaterial = loadVideoMaterial(video: computerModel.videoName) {
            videoBox.model?.materials = [videoMaterial]
        }
        
        videoBox.name = "\(computerModel.videoName)Screen"
        
        anchor.addChild(videoBox)
        return anchor
    }
    
    func loadVideoMaterial(video: String) -> VideoMaterial? {
        guard let pathToVideo = Bundle.main.path(forResource: video, ofType: "mp4") else { return nil }
        
        let videoURL = URL(fileURLWithPath: pathToVideo)
        let avPlayer = AVPlayer(url: videoURL)
        // 16:9 video
        let material = VideoMaterial(avPlayer: avPlayer)
        
        avPlayer.volume = 0.0
        
        return material
    }
    
    // MARK: update
    func updateUIView(_ uiView: ARView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
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
                            print("DEBUG: \(computer.anchorName)Anchor is anchored")
                            videoMaterial.avPlayer?.play()
                        } else {
                            videoMaterial.avPlayer?.pause()
                            print("DEBUG: pause \(computer.videoName)Screen")
                        }
                    }
                }
            }
        }
    }
}
