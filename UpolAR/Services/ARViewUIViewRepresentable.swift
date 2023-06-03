//
//  ARViewUIViewRepresentable.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 03.06.2023.
//

import Foundation

import SwiftUI
import RealityKit
import ARKit

struct ARViewUIViewRepresentable: UIViewRepresentable {
    typealias UIViewType = ARView
    
    @Binding var showModel: Bool
    
    var update: (_ uiView: ARView) -> Void

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        update(uiView)
    }
}
