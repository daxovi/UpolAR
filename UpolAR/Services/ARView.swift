//
//  ARView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 13.06.2023.
//

import Foundation
import ARKit
import RealityKit

extension ARView: ARCoachingOverlayViewDelegate {
    
    func addCoaching(plane: ARCoachingOverlayView.Goal) {
        
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.delegate = self
        coachingOverlay.session = self.session
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        coachingOverlay.goal = plane
        self.addSubview(coachingOverlay)
    }
    
    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        coachingOverlayView.activatesAutomatically = false
        //Ready to add objects
    }
    
// https://www.youtube.com/watch?v=mPJiRtNzIHw
    
    func enableTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        let tapLocation = recognizer.location(in: self)
        
        guard let rayResult = self.ray(through: tapLocation) else { return }
        
        let results = self.scene.raycast(origin: rayResult.origin, direction: rayResult.direction)
        
        if let firstResult = results.first {
            
        } else {
            let results = self.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .any)
            
            if let firstResult = results.first {
                let position = simd_make_float3(firstResult.worldTransform.columns.3)
                
            }
        }
    }
    
}

