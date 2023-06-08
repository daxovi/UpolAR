//
//  ARCompassModel.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 04.06.2023.
//

import RealityKit
import Foundation

struct ARCompassModel {
    func getModel() -> AnchorEntity {
        let modelURL = Bundle.main.url(forResource: "upol-arrow", withExtension: "usdz")!
        let model = try! Entity.load(contentsOf: modelURL)
        model.name = "point"
        
        // let anchor = AnchorEntity(plane: .horizontal)
        let anchor = AnchorEntity()
        
        model.transform = Transform(scale: .init(repeating: 0.05))
        anchor.addChild(model)
        return anchor
    }
}
