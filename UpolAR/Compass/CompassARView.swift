//
//  ARCompassViewModel.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 03.06.2023.
//

import SwiftUI
import RealityKit
import Combine

private var cancellables: Set<AnyCancellable> = []

struct CompassARView: UIViewRepresentable {
    typealias UIViewType = ARView
    
    @Binding var showModel: Bool
    
    let locationManager = LocationManager.shared
    
    // MARK: make
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        return arView
    }
    
    // MARK: update
    func updateUIView(_ uiView: ARView, context: Context) {
        addRemoveModel(uiView: uiView)
        rotateModel(uiView: uiView)
    }
    
    func rotateModel(uiView: ARView) {
        if uiView.scene.anchors.first != nil,
           let model = uiView.scene.anchors.first!.findEntity(named: "point"),
           let rotation = self.locationManager.headingToDestination
        {
            model.scale = .init(repeating: 0.0)
            
            var transform = Transform(pitch: 0, yaw: ((rotation+180) * .pi / 180), roll: 0)
            transform.scale = .init(repeating: 0.05)
            
            model.move(to: transform, relativeTo: model.parent, duration: 1)
            for animation in model.availableAnimations {
                model.playAnimation(animation.repeat())
            }
            print("DEBUG: model placed")
        }
    }
    
    func addModel(uiView: ARView) {
        let modelURL = Bundle.main.url(forResource: "upol-arrow", withExtension: "usdz")!
        let model = try! Entity.load(contentsOf: modelURL)
        model.name = "point"
        
        let anchor = AnchorEntity()
        // let anchor = AnchorEntity(plane: .horizontal)
        
        model.transform = Transform(scale: .init(repeating: 0.05))
        anchor.addChild(model)
        uiView.scene.addAnchor(anchor)
    }
    
    func removeAll(uiView: ARView) {
        uiView.scene.anchors.removeAll()
    }
    
    func addRemoveModel(uiView: ARView) {
        if showModel {
            addModel(uiView: uiView)
        } else {
            removeAll(uiView: uiView)
        }
    }
}

