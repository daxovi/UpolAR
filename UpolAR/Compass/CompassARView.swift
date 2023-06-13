//
//  ARCompassViewModel.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 03.06.2023.
//

import SwiftUI
import RealityKit
import ARKit
import Combine

var cancellables: [AnyCancellable] = []

struct CompassARView: UIViewRepresentable {
    typealias UIViewType = ARView
        
    let locationManager = LocationManager.shared
    
    // MARK: make
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.addCoaching(plane: .horizontalPlane)
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        config.environmentTexturing = .automatic
        config.frameSemantics.insert(.personSegmentationWithDepth)
        
        addModel(uiView: arView)
        
        arView.session.run(config)
        
        return arView
    }
    
    // MARK: update
    func updateUIView(_ uiView: ARView, context: Context) {
        
        /*
        addRemoveModel(uiView: uiView)
        
        if let model = uiView.scene.anchors.first?.findEntity(named: "point") {
            if model.isAnchored {
                print("DEBUG: model is anchored")
                
            }
        }
        */
        
    }
    
    func rotateModel(uiView: ARView) {
        if let model = uiView.scene.anchors.first?.findEntity(named: "point"),
           let rotation = self.locationManager.headingToDestination
        {
            var transform = Transform(pitch: 0, yaw: ((rotation+180) * .pi / 180), roll: 0)
            transform.scale = .init(repeating: 0.05)
            
            model.move(to: transform, relativeTo: model.parent, duration: 1)
            
            for animation in model.availableAnimations {
                model.playAnimation(animation.repeat())
            }
            print("DEBUG: model rotated")
        }
    }
    
    func addModel(uiView: ARView) {
        var cancellable: AnyCancellable? = nil
        
        cancellable = ModelEntity.loadModelAsync(named: "upol-arrow.usdz")
            .sink(receiveCompletion: { error in
                print("Unexpected error: \(error)")
                cancellable?.cancel()
            }, receiveValue: { model in
                model.name = "point"
                
                // let anchor = AnchorEntity()
                let bounds = SIMD2(repeating: Float(1))
                let anchor = AnchorEntity(plane: .horizontal, classification: .floor, minimumBounds: bounds)
                anchor.name = "anchor"
                
                model.transform = Transform(scale: .init(repeating: 0.00))
                anchor.addChild(model)
                uiView.scene.addAnchor(anchor)
                print("DEBUG: model placed")
                
                rotateModel(uiView: uiView)
                
                cancellable?.cancel()
            })
    }
    
    /*
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
     */
}

