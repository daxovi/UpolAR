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


struct CompassARView: UIViewRepresentable {
    typealias UIViewType = ARView
        
    // MARK: make
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.addCoaching(plane: .horizontalPlane)
        
        context.coordinator.view = arView
        arView.session.delegate = context.coordinator
        
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
        
    }
    
    func rotateModel(model: Entity) {
        let locationManager = LocationManager.shared

        if let rotation = locationManager.headingToDestination
        {
            if model.isAnchored {
                var transform = Transform(pitch: 0, yaw: ((rotation+180) * .pi / 180), roll: 0)
                transform.scale = .init(repeating: 0.05)
                
                model.move(to: transform, relativeTo: model.parent, duration: 0.5)
                
                for animation in model.availableAnimations {
                    model.playAnimation(animation.repeat())
                }
                print("DEBUG: model rotated: \(rotation)")
            } else {
                print("DEBUG: model not rotated")
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    // MARK: coordinator
    class Coordinator: NSObject, ARSessionDelegate {
        weak var view: ARView?
        var parent: CompassARView
        
        init(view: ARView? = nil, parent: CompassARView) {
            self.view = view
            self.parent = parent
        }
        
        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            if let model = view?.scene.findEntity(named: "point") {
                if model.isAnchored {
                    print("DEBUG: point found")
                    parent.rotateModel(model: model)
                    //    model.name = "rotated point"
                }
            }
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
                
                let bounds = SIMD2(repeating: Float(1))
                let anchor = AnchorEntity(plane: .horizontal, classification: .floor, minimumBounds: bounds)
                anchor.name = "anchor"
                
                model.transform = Transform(scale: .init(repeating: 0.00))
                anchor.addChild(model)
                uiView.scene.addAnchor(anchor)
                print("DEBUG: model placed")
                
                cancellable?.cancel()
            })
    }
}
