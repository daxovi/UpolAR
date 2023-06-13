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
    
}

