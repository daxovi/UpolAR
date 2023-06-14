//
//  PortalARView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 10.06.2023.
//

import SwiftUI
import RealityKit
import ARKit
import Combine

struct PortalARView: UIViewRepresentable {
    typealias UIViewType = ARView
        
    @Binding var roomNr: Int
    
    var textures: [TextureResource] = []
    
    // MARK: make
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.addCoaching(plane: .tracking)
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        config.environmentTexturing = .automatic
        config.frameSemantics.insert(.personSegmentationWithDepth)
        
        arView.session.run(config)
        
        let anchor = AnchorEntity()
        anchor.name = "rootAnchor"
        arView.scene.addAnchor(anchor)
        
        loadMask(anchor: anchor)
        loadLogo(anchor: anchor)

        return arView
    }
    
    // MARK: update
    func updateUIView(_ arView: ARView, context: Context) {
        if roomNr == 0 {
            
            
            
            let imageName = "christmas"
            
            removeRoom(arView: arView)
            
            let anchor = AnchorEntity()
            anchor.name = "roomAnchor"
            
            loadRoom(anchor: anchor, textureFileName: imageName)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                arView.scene.addAnchor(anchor)
            }
            
        }
        if roomNr == 1 {
            
            let imageName = "sunset"
            
            removeRoom(arView: arView)
            
            let anchor = AnchorEntity()
            anchor.name = "roomAnchor"
            loadRoom(anchor: anchor, textureFileName: imageName)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                arView.scene.addAnchor(anchor)
            }
                
        }
    }
    
    func removeRoom(arView: ARView) {
        rotateModel(arView: arView)
            for anchor in arView.scene.anchors {
                if anchor.name == "roomAnchor" {
                    anchor.removeFromParent()
                }
        }
        
        print("DEBUG: všechny anchors jsou vymazané")
    }
    
    func rotateModel(arView: ARView) {
        if let anchor = arView.scene.findEntity(named: "logoModel") {
            print("DEBUG: anchor s názvem logoModel existuje")
            // todop opravit rotaci nebo vyměnit za animaci v USDZ
            let transform = Transform(pitch: 0, yaw: (.pi), roll: 0)
            anchor.move(to: transform, relativeTo: anchor.self, duration: 0.5, timingFunction: .easeIn)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.58) {
                let transform = Transform(pitch: 0, yaw: (.pi), roll: 0)
                anchor.move(to: transform, relativeTo: anchor.self, duration: 0.5, timingFunction: .easeOut)
            }
        } else {
            print("DEBUG: anchor s názvem logoAnchor se nepodařilo najít")
        }
        print("DEBUG: všechny anchors jsou vymazané")
    }
    
    func loadLogo(anchor: AnchorEntity) {
        var logoRequest: AnyCancellable? = nil
        logoRequest = ModelEntity.loadModelAsync(named: "room_logo.usdz")
            .sink(receiveCompletion: { error in
                print("Unexpected error: \(error)")
                logoRequest?.cancel()
            }, receiveValue: { model in
                print("DEBUG: model room_logo.usdz je nahraný.")
                let colorMaterial = SimpleMaterial(color: UIColor(named: "BlueColor") ?? .blue, isMetallic: false)
                model.model?.materials = [colorMaterial]
                model.position = [0, 1.54, -0.96]
                model.name = "logoModel"
                
                anchor.addChild(model)
                
                logoRequest?.cancel()
            })
    }
    
    func loadMask(anchor: AnchorEntity) {
        var maskRequest: AnyCancellable? = nil
        maskRequest = ModelEntity.loadModelAsync(named: "room_mask.usdz")
            .sink(receiveCompletion: { error in
                print("Unexpected error: \(error)")
                maskRequest?.cancel()
            }, receiveValue: { model in
                print("DEBUG: model room_mask.usdz je nahraný.")
                let occlusionMaterial = OcclusionMaterial()
                model.model?.materials = [occlusionMaterial]
                model.position = [0, 0, -2.5]
                model.name = "mask"
                
                anchor.addChild(model)
                
                maskRequest?.cancel()
            })
    }
    
    /*
    
    func loadTexture(arView: ARView, textureFileName: String) {
        if let model = arView.scene.findEntity(named: "roomModel") as? ModelEntity {
            if let url = Bundle.main.url(forResource: textureFileName, withExtension: ".jpg") {
                print("DEBUG: texturu \(textureFileName) se podařilo nalézt")
                var textureRequest: AnyCancellable? = nil
                print("DEBUG: texturu \(textureFileName) se podařilo nalézt")
                textureRequest = TextureResource.loadAsync(contentsOf: url)
                    .sink(receiveCompletion: { error in
                        print("Unexpected error: \(error)")
                        textureRequest?.cancel()
                    }, receiveValue: { (texture) in
                        print("DEBUG: textura \(textureFileName) je nahraná.")
                        var material = UnlitMaterial()
                        material.color.texture = .init(texture)
                        model.model?.materials = [material]
                    })
            }
        }
    }
     
     */
    
    func loadRoom(anchor: AnchorEntity, textureFileName: String) {
        if let url = Bundle.main.url(forResource: textureFileName, withExtension: ".jpg") {
            print("DEBUG: texturu \(textureFileName) se podařilo nalézt")
            var textureRequest: AnyCancellable? = nil
            print("DEBUG: texturu \(textureFileName) se podařilo nalézt")
            textureRequest = TextureResource.loadAsync(contentsOf: url)
                .sink(receiveCompletion: { error in
                    print("Unexpected error: \(error)")
                    textureRequest?.cancel()
                }, receiveValue: { (texture) in
                    print("DEBUG: textura \(textureFileName) je nahraná.")
                    var material = UnlitMaterial()
                    material.color.texture = .init(texture)
                    
                    var roomRequest: AnyCancellable? = nil
                    roomRequest = ModelEntity.loadModelAsync(named: "room.usdz")
                        .sink(receiveCompletion: { error in
                            print("Unexpected error: \(error)")
                            roomRequest?.cancel()
                        }, receiveValue: { model in
                            model.model?.materials = [material]
                            model.position = [0, 0, -2.5]
                            model.name = "roomModel"
                                                        
                            anchor.addChild(model)
                            
                            
                            roomRequest?.cancel()
                        })
                    
                    textureRequest?.cancel()
                })

        } else {
            print("DEBUG: texturu \(textureFileName) se nepodařilo nahrát")
        }
    }
}
