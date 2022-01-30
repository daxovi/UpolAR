//
//  GamesARView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 16.01.2022.
//

import SwiftUI
import RealityKit
import Combine

var collisionSubscribing:Cancellable?

struct GamesARView: UIViewRepresentable {
    @Binding var position: Float?
    @Binding var isPressedStart: Bool
    let force: Float = 15
    
    // modely
    var paddleModel = ModelEntity(mesh: MeshResource.generateBox(width: 0.1, height: 0.02, depth: 0.02, cornerRadius: 0, splitFaces: false),
                                  materials: [SimpleMaterial(color: .green, roughness: 1, isMetallic: false)])
    var ballModel = ModelEntity(mesh: MeshResource.generateSphere(radius: 0.01),
                                materials: [SimpleMaterial(color: .red, roughness: 1, isMetallic: false)])
    
    // Physics body component
    let kinematicBodyComponent = PhysicsBodyComponent(
        massProperties: .default,
        material: .generate(friction: 0, restitution: 0),
        mode: .kinematic)
    let brickBodyComponent = PhysicsBodyComponent(
        massProperties: .default,
        material: .generate(friction: 0, restitution: 0),
        mode: .kinematic)
    let dynamicBodyComponent = PhysicsBodyComponent(
        massProperties: PhysicsMassProperties(mass: 2),
        material: .generate(friction: 0, restitution: 0),
        mode: .dynamic)
    
    // material
    let occlusionMaterial = OcclusionMaterial()
    let transparentMaterial = SimpleMaterial(color: .blue.withAlphaComponent(0.0), roughness: 1, isMetallic: false)
    let simpleMaterial = SimpleMaterial(color: .blue, roughness: 1, isMetallic: false)
    let unlitMaterial = UnlitMaterial(color: .blue)
    
    func makeUIView(context: Context) -> ARView {
        
        // generování anchor ze souboru v resources - nefunguje ovládání gravitace
        /*
        let arView = ARView(frame: .zero)
        let anchor = AnchorEntity(.image(group: "AR Resources", name: "games"))
        anchor.generateCollisionShapes(recursive: false)
        arView.scene.addAnchor(anchor)
         */
        
        let arView = ARView(frame: .zero)
        // Load the "Breakout" scene from the "GameScene" Reality File
        let anchor = try! GameScene.loadBreakout()
        anchor.generateCollisionShapes(recursive: false)
        
        arView.scene.anchors.append(anchor)

        // podlaha
        let floor = MeshResource.generateBox(width: 0.297, height: 0.001, depth: 0.420)
        let floorModel = ModelEntity(mesh: floor, materials: [occlusionMaterial])
        floorModel.components[PhysicsBodyComponent.self] = kinematicBodyComponent
        floorModel.generateCollisionShapes(recursive: false)
        anchor.addChild(floorModel)
        
        // vrchní kryt
        let roofModel = ModelEntity(mesh: floor, materials: [transparentMaterial])
        roofModel.components[PhysicsBodyComponent.self] = kinematicBodyComponent
        roofModel.generateCollisionShapes(recursive: false)
        roofModel.position = [0, 0.02, 0]
        anchor.addChild(roofModel)
        
        let top = MeshResource.generateBox(width: 0.297, height: 0.02, depth: 0.02)
        let side = MeshResource.generateBox(width: 0.02, height: 0.02, depth: 0.420)
        
        let rightModel = ModelEntity(mesh: side, materials: [transparentMaterial])
        rightModel.position = [0.1585, 0, 0]
        rightModel.name = "rightModel"
        let leftModel = ModelEntity(mesh: side, materials: [transparentMaterial])
        leftModel.position = [-0.1585, 0, 0]
        leftModel.name = "leftModel"
        
        let topModel = ModelEntity(mesh: top, materials: [transparentMaterial])
        topModel.position = [0, 0, -0.22]
        topModel.name = "topModel"
        let bottomModel = ModelEntity(mesh: top, materials: [transparentMaterial])
        bottomModel.position = [0, 0, 0.22]
        bottomModel.name = "bottomModel"
        
        let sides:[ModelEntity] = [rightModel, leftModel, topModel, bottomModel]
        for model in sides {
            model.components[PhysicsBodyComponent.self] = kinematicBodyComponent
            model.generateCollisionShapes(recursive: false)
            anchor.addChild(model)
        }
        
        // brick
        let brick = MeshResource.generateBox(width: 0.08, height: 0.02, depth: 0.01, cornerRadius: 0, splitFaces: false)
        for column in -1..<2 {
            for row in 0..<6 {
                let brickModel = ModelEntity(mesh: brick, materials: [unlitMaterial])
                brickModel.components[PhysicsBodyComponent.self] = brickBodyComponent
                brickModel.generateCollisionShapes(recursive: false)
                brickModel.position = [Float(column) * 0.09, 0, -0.075 - Float(row) * Float(0.02)]
                brickModel.name = "brick"
                anchor.addChild(brickModel)
            }
        }
        
        /*
        let brick = MeshResource.generateBox(width: 0.08, height: 0.02, depth: 0.01, cornerRadius: 0, splitFaces: false)
        let brickModel = ModelEntity(mesh: brick, materials: [simpleMaterial])
        brickModel.components[PhysicsBodyComponent.self] = brickBodyComponent
        brickModel.generateCollisionShapes(recursive: false)
        brickModel.position = [0, 0, -0.075]
        anchor.addChild(brickModel)
         */
        
                
        // kinematic = odrazí ostatní ale nepohne se
        // dynamic = odrazí a pohne se
        paddleModel.components[PhysicsBodyComponent.self] = kinematicBodyComponent
        paddleModel.generateCollisionShapes(recursive: false)
        
        ballModel.components[PhysicsBodyComponent.self] = dynamicBodyComponent
        ballModel.generateCollisionShapes(recursive: false)
        
        ballModel.name = "ballModel"
        ballModel.isEnabled = false
        paddleModel.name = "paddleModel"
        
        paddleModel.position = [0, 0, 0.18]
        anchor.addChild(paddleModel)
        anchor.addChild(ballModel)
        
                
        collisionSubscribing = arView.scene.subscribe(to: CollisionEvents.Began.self) { event in
            ballModel.clearForcesAndTorques()

            if event.entityA == ballModel, event.entityB == leftModel {
                print("left!")
                ballModel.addForce([force,0,0], relativeTo: ballModel)
            }
            
            if event.entityA == ballModel, event.entityB == rightModel {
                print("right!")
                ballModel.addForce([-1*(force),0,0], relativeTo: ballModel)
            }
            
            if event.entityA == ballModel, event.entityB == topModel {
                print("top!")
                ballModel.addForce([0,0,force], relativeTo: ballModel)
            }
            
            if event.entityA == ballModel, event.entityB == paddleModel {
                print("paddle!")
                ballModel.addForce([0,0,-1*(force)], relativeTo: ballModel)
            }
            
            if event.entityA == ballModel, event.entityB == bottomModel {
                print("bottom!")
                DispatchQueue.main.async {
                    ballModel.isEnabled = false
                    ballModel.position = [0, 0, 0]
                }
            }
            
            if event.entityA == ballModel, event.entityB.name == "brick" {
                print("brick!")
                ballModel.addForce([0,0,force], relativeTo: ballModel)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    event.entityB.isEnabled = false
                })
            }
            
            /*
            if event.entityA == puckModel, event.entityB == brickModel {
                print("HIT!")
                hit = "HIT"
                puckModel.addForce([5,0,0], relativeTo: puckModel)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    sceneElement.removeChild(brickModel)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                sceneElement.addChild(brickModel)
                }
            }
            
            if event.entityA == puckModel, event.entityB == newBrick {
                print("HIT!")
                hit = "HIT"
                puckModel.addForce([5,0,0], relativeTo: puckModel)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    sceneElement.removeChild(newBrick)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                sceneElement.addChild(newBrick)
                }
            }
             */
        }
        
        
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // pohyb padle
        if let entityPosition = self.position {
            paddleModel.position = [entityPosition, 0, 0.18]
            //uiView.scene.anchors[0].addChild(paddleModel)
            
            /*
            DispatchQueue.main.async {
                position = nil
            }
             */
        }
        
        // start
        if isPressedStart {
            ballModel.isEnabled = false
            ballModel.isEnabled = true
            ballModel.position = [0, 0, 0]
            ballModel.clearForcesAndTorques()
            ballModel.addForce([force/2,0,force/2], relativeTo: ballModel)
            // uiView.scene.anchors[0].addChild(ballModel.clone(recursive: true))
            
            DispatchQueue.main.async {
                isPressedStart = false
            }
        }
    }
}
