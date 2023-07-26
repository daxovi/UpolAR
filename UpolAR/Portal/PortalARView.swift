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
    /// Propojuje proměnnou roomNr se SwiftUI. Při změně stupstí funkcí updateUIView a zobrazí požadovanou scénu podle předaného čísla.
    @Binding var roomFileName: String
    var fileExtension: String
    
    // MARK: make
    // spouští první ARView s konfigurací a modely
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.addCoaching(plane: .tracking)
        /// Konfigurace pro ARView.
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        config.environmentTexturing = .automatic
        // .personSegmentationWithDepth přidá do ARView konfiguraci kdy můžou být 3D modely za osobou nebo před ní podle hloubky scény
        config.frameSemantics.insert(.personSegmentationWithDepth)
        // spustí scénu s vytvořenou konfigurací
        arView.session.run(config)
        /// Kotva na kterou se připevní další modely.
        let anchor = AnchorEntity()
        anchor.name = "rootAnchor"
        arView.scene.addAnchor(anchor)
        // nahraje masku a logo UPOL a přidá je do kotvy anchor
        loadMask(anchor: anchor)
        loadLogo(anchor: anchor)
        
        return arView
    }
    
    // MARK: update
    // aktualizuje  ARView na základě změn @Binding ze SwiftUI
    func updateUIView(_ arView: ARView, context: Context) {
        removeRoom(arView: arView)
        /// Kotva na kterou se připevní další modely.
        let anchor = AnchorEntity()
        anchor.name = "roomAnchor"
        // nahraje model s texturou první místnosti a přidá ho do kotvy anchor
        loadRoom(anchor: anchor, textureFileName: roomFileName)
        // přidá kotvu do scény
        arView.scene.addAnchor(anchor)
    }
    
    /// Vyhledá v ARView model s názvem "roomAnchor" a vymaže ho ze scény
    /// - parameter arView: ARView ve kterém metoda hledá model podle názvu
    func removeRoom(arView: ARView) {
        for anchor in arView.scene.anchors {
            if anchor.name == "roomAnchor" {
                anchor.removeFromParent()
            }
        }
    }
    
    /// Nahraje USDZ model loga UPOL, přiřadí materiál s modrou barvou a připevní ho na kotvu anchor
    /// - parameter anchor: kotva na kterou mám být model připevněný
    func loadLogo(anchor: AnchorEntity) {
        var logoRequest: AnyCancellable? = nil
        logoRequest = ModelEntity.loadModelAsync(named: "room_logo.usdz")
            .sink(receiveCompletion: { error in
                logoRequest?.cancel()
            }, receiveValue: { model in
                let colorMaterial = SimpleMaterial(color: UIColor(named: "BlueColor") ?? .blue, isMetallic: false)
                model.model?.materials = [colorMaterial]
                model.position = [0, 1.54, -0.96]
                model.name = "logoModel"
                anchor.addChild(model)
                logoRequest?.cancel()
            })
    }
    
    /// Nahraje USDZ model masky, přiřadí mu OcclusionMaterial, který zakrývá všechny ostatní modely v pozadí a připevní ho na kotvu anchor
    /// - parameter anchor: kotva na kterou mám být model připevněný
    func loadMask(anchor: AnchorEntity) {
        var maskRequest: AnyCancellable? = nil
        maskRequest = ModelEntity.loadModelAsync(named: "room_mask.usdz")
            .sink(receiveCompletion: { error in
                maskRequest?.cancel()
            }, receiveValue: { model in
                let occlusionMaterial = OcclusionMaterial()
                model.model?.materials = [occlusionMaterial]
                model.position = [0, 0, -2.5]
                model.name = "mask"
                anchor.addChild(model)
                maskRequest?.cancel()
            })
    }
    
    /// Nahraje USDZ model místnosti s texturou podle názvu souboru a připevní ho na kotvu
    /// - parameter anchor: kotva na kterou mám být model připevněný
    /// - parameter textureFileName: jméno souboru textury ve formátu JPG (bez přípony)
    func loadRoom(anchor: AnchorEntity, textureFileName: String) {
        if let url = Bundle.main.url(forResource: textureFileName, withExtension: fileExtension) {
            var textureRequest: AnyCancellable? = nil
            textureRequest = TextureResource.loadAsync(contentsOf: url)
                .sink(receiveCompletion: { error in
                    textureRequest?.cancel()
                }, receiveValue: { (texture) in
                    var material = UnlitMaterial()
                    material.color.texture = .init(texture)
                    var roomRequest: AnyCancellable? = nil
                    roomRequest = ModelEntity.loadModelAsync(named: "room.usdz")
                        .sink(receiveCompletion: { error in
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
        }
    }
}
