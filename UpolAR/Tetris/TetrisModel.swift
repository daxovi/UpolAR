//
//  TetrisModel.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 22.07.2023.
//

import RealityKit
import SwiftUI

struct TetrisModel {
    let sizeOfBlock: Float
    
    private let blueMaterial = UnlitMaterial(color: UIColor(named: "BlueColor") ?? .blue)
    private let whiteMaterial = UnlitMaterial(color: .white)
    private let orangeMaterial = UnlitMaterial(color: UIColor(named: "AccentColor") ?? .red)
    
    func getStartButton() -> ModelEntity {
        let startMesh = MeshResource.generateBox(width: 0.161, height: 0.005, depth: 0.038, cornerRadius: 0)
        let startButton = ModelEntity(mesh: startMesh, materials: [blueMaterial])
        startButton.name = "startButton"
        startButton.position = [0.3725, 0, 0.328]
        startButton.generateCollisionShapes(recursive: true)
        
        let startText = ModelEntity(mesh: .generateText("START", extrusionDepth: 0.001, font: .systemFont(ofSize: 0.02, weight: .bold), containerFrame: CGRect.zero, alignment: .center, lineBreakMode: .byCharWrapping), materials: [whiteMaterial])
        startText.transform = Transform(pitch: -(.pi/2), yaw: 0, roll: 0)
        startText.position = [-0.038, 0.003, 0.01]
        startButton.addChild(startText)
        
        return startButton
    }
    
    func getTextPressStart() -> ModelEntity {
            let text = ModelEntity(mesh: .generateText("PRESS START \n ", extrusionDepth: 0.001, font: .systemFont(ofSize: 0.02, weight: .bold), containerFrame: CGRect.zero, alignment: .left, lineBreakMode: .byCharWrapping), materials: [whiteMaterial])
            text.transform = Transform(pitch: -(.pi/2), yaw: 0, roll: 0)
            
            return text
    }
    
    func getTextScore(score: Int) -> ModelEntity {
        let text = ModelEntity(mesh: .generateText("SCORE: \(score) \n ", extrusionDepth: 0.001, font: .systemFont(ofSize: 0.02, weight: .bold), containerFrame: CGRect.zero, alignment: .left, lineBreakMode: .byCharWrapping),
                               materials: [UnlitMaterial(color: .white)])
        text.transform = Transform(pitch: -(.pi/2), yaw: 0, roll: 0)
        
        return text
    }
    
    func getTextGameOver(score: Int) -> ModelEntity {
        let text = ModelEntity(mesh: .generateText("GAME OVER \nSCORE: \(score)", extrusionDepth: 0.001, font: .systemFont(ofSize: 0.02, weight: .bold), containerFrame: CGRect.zero, alignment: .left, lineBreakMode: .byCharWrapping),
                               materials: [whiteMaterial])
        text.transform = Transform(pitch: -(.pi/2), yaw: 0, roll: 0)

        return text
    }
    
    func getWhiteBoxModel() -> ModelEntity {
        let boxMesh = MeshResource.generateBox(width: sizeOfBlock, height: 0.005, depth: sizeOfBlock)
        let boxModel = ModelEntity(mesh: boxMesh, materials: [whiteMaterial])
        return boxModel
    }
    
    func getOrangeBoxModel() -> ModelEntity {
        let boxMesh = MeshResource.generateBox(width: sizeOfBlock, height: 0.005, depth: sizeOfBlock)
        let boxModel = ModelEntity(mesh: boxMesh, materials: [orangeMaterial])
        return boxModel
    }
}
