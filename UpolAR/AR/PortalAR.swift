//
//  VideoPortalAR.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 04.03.2022.
//

import SwiftUI
import RealityKit
import ARKit

struct PortalAR: UIViewControllerRepresentable {
    typealias UIViewControllerType = ARViewController
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> ARViewController {
        let viewController = ARViewController()
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: ARViewController, context: Context) {
        
    }
    
    class Coordinator: NSObject {
        var parent: PortalAR
        init(_ parent: PortalAR) {
            self.parent = parent
        }
    }
}

class ARViewController: UIViewController {
    let spaceName = "SphereSpace.usdz"
    let imageName = "christmas"
    let imageExtension = "jpg"
    
    override func viewDidAppear(_ animated: Bool) {
        let arView = ARView(frame: .zero)
        view = arView
        
        let anchorEntity = AnchorEntity()
        arView.scene.addAnchor(anchorEntity)
        
        let occlusionMaterial = OcclusionMaterial()
        let colorMaterial = SimpleMaterial(color: UIColor(named: "BlueColor") ?? .blue, isMetallic: false)
        // let occlusionEntity = ModelEntity(mesh: .generateSphere(radius: 1.51), materials: [unlitMaterial])
        let occlusionEntity = try! Entity.loadModel(named: "room_mask.usdz")
        occlusionEntity.model?.materials = [occlusionMaterial]
        occlusionEntity.position = [0, 0, -2.5]
        anchorEntity.addChild(occlusionEntity)
        
        if let url = Bundle.main.url(forResource: imageName, withExtension: imageExtension),
           let texture = try? TextureResource.load(contentsOf:url, withName:nil) {
            var imageMaterial = UnlitMaterial()
            imageMaterial.color.texture = .init(texture)
            let spaceModelEntity = try! Entity.loadModel(named: "room.usdz")
            spaceModelEntity.model?.materials = [imageMaterial]
            spaceModelEntity.position = [0, 0, -2.5]
            anchorEntity.addChild(spaceModelEntity)
            
             let logoEntity = try! Entity.loadModel(named: "room_logo.usdz")
            logoEntity.model?.materials = [colorMaterial]
            logoEntity.position = [0, 1.54, -0.96]

             anchorEntity.addChild(logoEntity)
        } else {
            assertionFailure("Could not load the image asset.")
        }
        
        let config = ARWorldTrackingConfiguration()
        arView.session.run(config)
    }
}
