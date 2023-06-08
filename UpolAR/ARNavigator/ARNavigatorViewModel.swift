//
//  ARNavigatorViewModel.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 07.06.2023.
//

import SwiftUI
import RealityKit

class ARNavigatorViewModel: ObservableObject {
    @Published var showModel = true
    
    func update(uiView: ARView) {
        let anchor = AnchorEntity(.image(group: "AR Resources", name: "arrow"))

        let box = ModelEntity(mesh: .generateBox(size: simd_make_float3(0.1, 0.03, 0.05)))
        
        anchor.addChild(box)
        uiView.scene.anchors.append(anchor)
        
        let anchor2 = AnchorEntity(.image(group: "AR Resources", name: "o1"))

        let box2 = ModelEntity(mesh: .generateBox(size: simd_make_float3(0.03, 0.01, 0.05)))
        
        anchor2.addChild(box2)
        uiView.scene.anchors.append(anchor2)
    }
}
