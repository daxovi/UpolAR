//
//  ComputerModel.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 25.06.2023.
//

import RealityKit
import AVFoundation

class ComputerModel {
    var screenWidth: Float
    var screenHeight: Float
    var anchorName: String
    var videoName: String
    
    init(screenWidth: Float, screenHeight: Float, anchorName: String, videoName: String) {
        self.screenWidth = screenWidth
        self.screenHeight = screenHeight
        self.anchorName = anchorName
        self.videoName = videoName
    }
    
    func getModel() -> AnchorEntity {
        let anchor = AnchorEntity(.image(group: "AR Resources", name: anchorName))
        anchor.name = "\(anchorName)Anchor"
        
        let box = MeshResource.generateBox(width: screenWidth, height: 0.001, depth: screenHeight)
        let videoBox = ModelEntity(mesh: box)
        if let videoMaterial = loadVideoMaterial() {
            videoBox.model?.materials = [videoMaterial]
        }
        
        videoBox.name = "\(videoName)Screen"
        
        anchor.addChild(videoBox)
        return anchor
    }
    
    private func loadVideoMaterial() -> VideoMaterial? {
        guard let pathToVideo = Bundle.main.path(forResource: videoName, ofType: "mp4") else { return nil }
        
        let videoURL = URL(fileURLWithPath: pathToVideo)
        let avPlayer = AVPlayer(url: videoURL)
        // 16:9 video
        let material = VideoMaterial(avPlayer: avPlayer)
        
        avPlayer.volume = 0.0
        
        return material
    }
}
