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
    
    // MARK: make
    // spouští první ARView s konfigurací a modely
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.addCoaching(plane: .tracking)
        
        let anchor = AnchorEntity(.image(group: "AR Resources", name: "cup"))
        anchor.name = "boardAnchor"
        arView.scene.addAnchor(anchor)
        
        return arView
    }
    
    // MARK: update
    // aktualizuje  ARView na základě změn @Binding ze SwiftUI
    func updateUIView(_ arView: ARView, context: Context) {
        
        print("DEBUG in update: board: \(board.description)")
        
        /// Kotva na kterou se připevní další modely.
        guard let anchor = arView.scene.findEntity(named: "boardAnchor") as? AnchorEntity else { return }
        
        anchor.children.removeAll()
        
        let boxMesh = MeshResource.generateBox(size: 0.02)
        
        for rowIndex in (0..<board.count) {
            for columnIndex in (0..<board[rowIndex].count) {
                
                // doleva doprava, k sobě od sebe, nahoru dolu
                let position: SIMD3<Float> = [Float(columnIndex) * 0.02, 0, Float(rowIndex) * 0.02]
                
                if board[rowIndex][columnIndex] == 1 {
                    let boxModel = ModelEntity(mesh: boxMesh, materials: [SimpleMaterial(color: .blue, isMetallic: false)])
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
        
        // přidá kotvu do scény
        arView.scene.addAnchor(anchor)
    }
}

