//
//  PortalARView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 10.06.2023.
//

import SwiftUI
import RealityKit
import Combine

struct PortalARView: UIViewRepresentable {
    typealias UIViewType = ARView
    
    @Binding var roomNr: Int
    
    // MARK: make
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        let anchor = AnchorEntity()
        anchor.name = "anchor"
        arView.scene.addAnchor(anchor)

        return arView
    }
    
    // MARK: update
    func updateUIView(_ arView: ARView, context: Context) {
        if roomNr == 1 {
            
            let imageName = "christmas"
            
            removeRoom(arView: arView)
            
            let anchor = AnchorEntity()
            arView.scene.addAnchor(anchor)
            
            loadMask(anchor: anchor)
            
            loadLogo(anchor: anchor)
            
            loadRoom(anchor: anchor, textureFileName: imageName)
            
            arView.scene.addAnchor(anchor)
        }
        if roomNr == 2 {
            
            let imageName = "sunset"
            
            removeRoom(arView: arView)
            
            let anchor = AnchorEntity()
            arView.scene.addAnchor(anchor)
            
            loadMask(anchor: anchor)
            loadRoom(anchor: anchor, textureFileName: "sunset")
            loadLogo(anchor: anchor)
            
            
            
            arView.scene.addAnchor(anchor)
        }
    }
    
    func removeRoom(arView: ARView) {
        arView.scene.anchors.removeAll()
        print("DEBUG: všechny anchors jsou vymazan=")
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
    
    func loadRoom(anchor: AnchorEntity, textureFileName: String) {
        if let url = Bundle.main.url(forResource: textureFileName, withExtension: ".jpg") {
            print("DEBUG: texturu \(textureFileName) se podařilo nahrát")
            var textureRequest: AnyCancellable? = nil
            print("DEBUG: texturu \(textureFileName) se podařilo nahrát")
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
                            model.name = "room"
                            
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

