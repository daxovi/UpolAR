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
    let model = TetrisModel(sizeOfBlock: 0.019)
    
    // MARK: make
    // spouští první ARView s konfigurací a modely
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.addCoaching(plane: .tracking)
        context.coordinator.view = arView
        arView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap)))
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
        let startButton = model.getStartButton()
        anchor.addChild(startButton)
        switch gameState {
        case .ready:
            let text = model.getTextPressStart()
            text.position = textPosition
            anchor.addChild(text)
        case .play:
            for rowIndex in (0..<board.count) {
                for columnIndex in (0..<board[rowIndex].count) {
                    // doleva doprava, k sobě od sebe, nahoru dolu
                    let position: SIMD3<Float> = [Float(columnIndex) * sizeOfBlock, 0, Float(rowIndex) * sizeOfBlock]
                    if board[rowIndex][columnIndex] == 1 {
                        let boxModel = model.getWhiteBoxModel()
                        boxModel.position = position
                        anchor.addChild(boxModel)
                    }
                    if board[rowIndex][columnIndex] == 2 {
                        let boxModel = model.getOrangeBoxModel()
                        boxModel.position = position
                        anchor.addChild(boxModel)
                    }
                }
            }
            
            let text = model.getTextScore(score: score)
            text.position = textPosition
            anchor.addChild(text)
        case .end:
            let text = model.getTextGameOver(score: finalScore)
            text.position = textPosition
            anchor.addChild(text)
        }
        // přidá kotvu do scény
        arView.scene.addAnchor(anchor)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}

class Coordinator: NSObject {
    weak var view: ARView?
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        guard let view = self.view else { return }
        let tapLocation = recognizer.location(in: view)
        if let entity = view.entity(at: tapLocation) as? ModelEntity {
            if entity.name == "startButton" {
                TetrisViewModel.shared.start()
            }
        }
    }
}

