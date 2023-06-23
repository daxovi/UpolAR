//
//  TetrisARView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 22.06.2023.
//

import SwiftUI
import RealityKit

struct TetrisARView: UIViewRepresentable {
    typealias UIViewType = ARView
    
    /// Propojuje proměnnou board se SwiftUI. Při změně stupstí funkcí updateUIView a zobrazí požadovanou scénu podle předaného 2D pole čísel.
    @Binding var board: [[Int]]
    @Binding var score: Int
    @Binding var finalScore: Int
    @Binding var gameState: GameState
    let sizeOfBlock: Float = 0.019
    
    // MARK: make
    // spouští první ARView s konfigurací a modely
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.addCoaching(plane: .tracking)
        
        let anchor = AnchorEntity(.image(group: "AR Resources", name: "anchor_tetris"))
        anchor.name = "boardAnchor"
        anchor.position = [-0.24 + sizeOfBlock / 2, 0, -0.189 + sizeOfBlock / 2]
        arView.scene.addAnchor(anchor)
                
        return arView
    }
    
    // MARK: update
    // aktualizuje  ARView na základě změn @Binding ze SwiftUI
    func updateUIView(_ arView: ARView, context: Context) {
                
        /// Kotva na kterou se připevní další modely.
        guard let anchor = arView.scene.findEntity(named: "boardAnchor") as? AnchorEntity else { return }
        
        anchor.children.removeAll()
        
        let textPosition: SIMD3<Float> = [0.295, 0, 0.1]
        
        let startButton = ModelEntity(mesh: .generateBox(width: 0.161, height: 0.005, depth: 0.038, cornerRadius: 0.05), materials: [SimpleMaterial(color: .green, isMetallic: false)])
        startButton.name = "startButton"
        startButton.position = [0.3725, 0, 0.332]
        
        let startText = ModelEntity(mesh: .generateText("START", extrusionDepth: 0.001, font: .systemFont(ofSize: 0.02, weight: .bold), containerFrame: CGRect.zero, alignment: .center, lineBreakMode: .byCharWrapping), materials: [SimpleMaterial(color: .black, isMetallic: false)])
        startText.transform = Transform(pitch: -(.pi/2), yaw: 0, roll: 0)
        startText.position = [-0.038, 0.003, 0.01]
        startButton.addChild(startText)
        
        anchor.addChild(startButton)
        
        switch gameState {
        case .ready:
            let text = ModelEntity(mesh: .generateText("PRESS START \n ", extrusionDepth: 0.001, font: .systemFont(ofSize: 0.02, weight: .bold), containerFrame: CGRect.zero, alignment: .left, lineBreakMode: .byCharWrapping), materials: [SimpleMaterial(color: .white, isMetallic: false)])
            text.transform = Transform(pitch: -(.pi/2), yaw: 0, roll: 0)
            text.position = textPosition
            anchor.addChild(text)
            
        case .play:
            let boxMesh = MeshResource.generateBox(width: sizeOfBlock, height: 0.005, depth: sizeOfBlock)
            
            for rowIndex in (0..<board.count) {
                for columnIndex in (0..<board[rowIndex].count) {
                    
                    // doleva doprava, k sobě od sebe, nahoru dolu
                    let position: SIMD3<Float> = [Float(columnIndex) * sizeOfBlock, 0, Float(rowIndex) * sizeOfBlock]
                    
                    if board[rowIndex][columnIndex] == 1 {
                        let boxModel = ModelEntity(mesh: boxMesh, materials: [SimpleMaterial(color: .white, isMetallic: false)])
                        boxModel.position = position
                        anchor.addChild(boxModel)
                    }
                    
                    if board[rowIndex][columnIndex] == 2 {
                        let boxModel = ModelEntity(mesh: boxMesh, materials: [SimpleMaterial(color: .red, isMetallic: false)])
                        boxModel.position = position
                        anchor.addChild(boxModel)
                    }
                }
            }
            
            let text = ModelEntity(mesh: .generateText("SCORE: \(score) \n ", extrusionDepth: 0.001, font: .systemFont(ofSize: 0.02, weight: .bold), containerFrame: CGRect.zero, alignment: .left, lineBreakMode: .byCharWrapping),
                                   materials: [SimpleMaterial(color: .white, isMetallic: false)])
            text.transform = Transform(pitch: -(.pi/2), yaw: 0, roll: 0)
            text.position = textPosition

            anchor.addChild(text)
            
        case .end:
            let text = ModelEntity(mesh: .generateText("GAME OVER \nSCORE: \(finalScore)", extrusionDepth: 0.001, font: .systemFont(ofSize: 0.02, weight: .bold), containerFrame: CGRect.zero, alignment: .left, lineBreakMode: .byCharWrapping),
                                   materials: [SimpleMaterial(color: .white, isMetallic: false)])
            text.transform = Transform(pitch: -(.pi/2), yaw: 0, roll: 0)
            text.position = textPosition
            anchor.addChild(text)
        }
        
        
        
        // přidá kotvu do scény
        arView.scene.addAnchor(anchor)
    }
}

