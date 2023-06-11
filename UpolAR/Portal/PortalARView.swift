//
//  PortalARView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 10.06.2023.
//

import SwiftUI
import RealityKit

struct PortalARView: UIViewRepresentable {
    typealias UIViewType = ARView
    
    @Binding var roomNr: Int
    
    let spaceName = "SphereSpace.usdz"
    
    
    // MARK: make
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        return arView
    }
    
    // MARK: update
    func updateUIView(_ arView: ARView, context: Context) {
        if roomNr == 1 {
            
            let imageName = "christmas"
            let imageExtension = "jpg"
            
            removeRoom(arView: arView)
            
            let anchor = AnchorEntity()
            arView.scene.addAnchor(anchor)
            
            let occlusionMaterial = OcclusionMaterial()
            
            let colorMaterial = SimpleMaterial(color: UIColor(named: "BlueColor") ?? .blue, isMetallic: false)
            
            let occlusionEntity = try! Entity.loadModel(named: "room_mask.usdz")
            occlusionEntity.model?.materials = [occlusionMaterial]
            occlusionEntity.position = [0, 0, -2.5]
            
            anchor.addChild(occlusionEntity)
            
            if let url = Bundle.main.url(forResource: imageName, withExtension: imageExtension),
               let texture = try? TextureResource.load(contentsOf:url, withName:nil) {
                var imageMaterial = UnlitMaterial()
                imageMaterial.color.texture = .init(texture)
                let spaceModelEntity = try! Entity.loadModel(named: "room.usdz")
                spaceModelEntity.model?.materials = [imageMaterial]
                spaceModelEntity.position = [0, 0, -2.5]
                anchor.addChild(spaceModelEntity)
                
                let logoEntity = try! Entity.loadModel(named: "room_logo.usdz")
                logoEntity.model?.materials = [colorMaterial]
                logoEntity.position = [0, 1.54, -0.96]
                
                anchor.addChild(logoEntity)
            } else {
                assertionFailure("Nepodařilo se nahrát model")
            }
            arView.scene.addAnchor(anchor)
        }
        if roomNr == 2 {
            
            let imageName = "sunset"
            let imageExtension = "jpg"
            
            removeRoom(arView: arView)
            
            let anchor = AnchorEntity()
            anchor.name = "jmeno anchor"
            arView.scene.addAnchor(anchor)
            
            let occlusionMaterial = OcclusionMaterial()
            
            let colorMaterial = SimpleMaterial(color: UIColor(named: "BlueColor") ?? .blue, isMetallic: false)
            
            let occlusionEntity = try! Entity.loadModel(named: "room_mask.usdz")
            occlusionEntity.model?.materials = [occlusionMaterial]
            occlusionEntity.position = [0, 0, -2.5]
            
            anchor.addChild(occlusionEntity)
            
            if let url = Bundle.main.url(forResource: imageName, withExtension: imageExtension),
               let texture = try? TextureResource.load(contentsOf:url, withName:nil) {
                var imageMaterial = UnlitMaterial()
                imageMaterial.color.texture = .init(texture)
                let spaceModelEntity = try! Entity.loadModel(named: "room.usdz")
                spaceModelEntity.model?.materials = [imageMaterial]
                spaceModelEntity.position = [0, 0, -2.5]
                anchor.addChild(spaceModelEntity)
                
                let logoEntity = try! Entity.loadModel(named: "room_logo.usdz")
                logoEntity.name = "logo"
                logoEntity.model?.materials = [colorMaterial]
                logoEntity.position = [0, 1.54, -0.96]
                
                anchor.addChild(logoEntity)
            } else {
                assertionFailure("Nepodařilo se nahrát model")
            }
            arView.scene.addAnchor(anchor)
        }
    }
    
    func removeRoom(arView: ARView) {
        arView.scene.anchors.removeAll()
    }
}

