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
    
    var build: (_ arView: ARView) -> ()
    var update: (_ arView: ARView) -> ()

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        build(arView)
        return arView
    }
    
    func updateUIView(_ arView: ARView, context: Context) {
        update(arView)
    }
}
