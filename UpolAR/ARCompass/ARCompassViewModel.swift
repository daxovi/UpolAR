//
//  ARCompassViewModel.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 03.06.2023.
//

import SwiftUI
import RealityKit

class ARCompassViewModel: ObservableObject {
    
    let locationManager = LocationManager.shared
    let model = ARCompassModel()
    
    @Published var showModel = false
    
    func update(uiView: ARView) {
        addRemoveModel(uiView: uiView)
        rotateModel(uiView: uiView)
    }
    
    func toggleShowModel() {
        print("DEBUG: toggle: \(self.showModel.description)")
        self.showModel.toggle()
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
        let arrowModel = model.getModel()
        uiView.scene.addAnchor(arrowModel)
    }
    
    func removeAll(uiView: ARView) {
        uiView.scene.anchors.removeAll()
    }
    
    func addRemoveModel(uiView: ARView) {
        if self.showModel {
            print("DEBUG: add model")
            addModel(uiView: uiView)
        } else {
            print("DEBUG: remove all")
            removeAll(uiView: uiView)
        }
    }
    
}

