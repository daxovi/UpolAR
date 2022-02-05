//
//  GamesARView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 16.01.2022.
//

import SwiftUI
import RealityKit
import Combine
import AVFoundation

var collisionSubscribing: Cancellable?
var revealSubscribing: Cancellable?

var bricks = [ModelEntity]()

struct GamesARView: UIViewRepresentable {
    @Binding var position: Float?
    @Binding var isPressedStart: Bool
    @Binding var isGameOver: Bool
    @State var score = 0
    
    let force: Float = 15
    
    
    // modely
    var paddleModel = ModelEntity(mesh: MeshResource.generateBox(width: 0.1, height: 0.02, depth: 0.02, cornerRadius: 0, splitFaces: false),
                                  materials: [UnlitMaterial(color: .red)])
    var ballModel = ModelEntity(mesh: MeshResource.generateSphere(radius: 0.01),
                                materials: [UnlitMaterial(color: .white)])
    
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
    let unlitMaterial = UnlitMaterial(color: .white)
    
    let brickMaterial = UnlitMaterial(color: UIColor(Color("BlueColor")))
    
    func makeUIView(context: Context) -> ARView {
            
        let arView = ARView(frame: .zero)
        let anchor = try! GameScene.loadBreakout()
        anchor.generateCollisionShapes(recursive: false)
        
        arView.scene.anchors.append(anchor)

        // podlaha
        let floor = MeshResource.generatePlane(width: 0.297, depth: 0.420)
        let floorModel = ModelEntity(mesh: floor)
        floorModel.name = "floorModel"
        if let videoURL = Bundle.main.url(forResource: "breakout", withExtension: "mp4") {
            let asset = AVURLAsset(url: videoURL)
            let playerItem = AVPlayerItem(asset: asset)
            let player = AVPlayer(playerItem: playerItem)
            let videoMaterial = VideoMaterial(avPlayer: player) // AVPlayer から VideoMaterial をつくる
            floorModel.model?.materials = [videoMaterial]
            revealSubscribing = arView.scene.subscribe(to: SceneEvents.AnchoredStateChanged.self, on: anchor, { event in
                if event.anchor.isActive {
                    print("DEBUG: anchorEntity is active!")
                    // player.seek(to: .zero)
                    player.play()
                    
                }
                
            })}
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
                let brickModel = ModelEntity(mesh: brick, materials: [brickMaterial])
                brickModel.components[PhysicsBodyComponent.self] = brickBodyComponent
                brickModel.generateCollisionShapes(recursive: false)
                brickModel.position = [Float(column) * 0.09, 0, -0.075 - Float(row) * Float(0.02)]
                brickModel.name = "brick"
                bricks.append(brickModel)
                anchor.addChild(brickModel)
            }
        }
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
            /*
            print("DEBUG: ballModel x pozice: \(ballModel.position.x)") // -0.13838117
            print("DEBUG: ballModel y pozice: \(ballModel.position.y)") // 0.011322738
            print("DEBUG: ballModel z pozice: \(ballModel.position.z)") // -0.1967 0.1589484
                        */
            
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
                    gameOver()
                }
            }
            
            if event.entityA == ballModel, event.entityB.name == "brick" {
                print("brick!")
                ballModel.addForce([0,0,force], relativeTo: ballModel)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    event.entityB.isEnabled = false
                    var isBrickEnabled = false
                    for brick in bricks {
                        isBrickEnabled = isBrickEnabled || brick.isEnabled
                    }
                    isGameOver = !isBrickEnabled
                    score += 1
                    print("DEBUG: Score: \(score)")
                    if isGameOver {
                        gameOver()
                    }
                })
            }
        }
        return arView
    }
    
    func gameOver() {
        print("DEBUG: Game over")
        ballModel.isEnabled = false
        isGameOver = true
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // pohyb padle
        if let entityPosition = self.position {
            paddleModel.position = [entityPosition, 0, 0.18]
        }
        
        if score >= 0 {
            if let oldScore = uiView.scene.anchors[0].findEntity(named: "testScore") {
                uiView.scene.anchors[0].removeChild(oldScore)
            }
            if score > 0 {
                let text = ModelEntity(mesh: .generateText("\(score)", extrusionDepth: 0.001, font: .systemFont(ofSize: 0.1, weight: .bold), containerFrame: CGRect.zero, alignment: .center, lineBreakMode: .byCharWrapping), materials: [unlitMaterial])
                text.name = "testScore"
                text.transform = Transform(pitch: -(.pi/2), yaw: 0, roll: 0)
                
                if score > 9 {
                    text.position = [-0.062, 0, 0.05]
                } else {
                    text.position = [-0.032, 0, 0.05]
                }
                uiView.scene.anchors[0].addChild(text)
            }
        }
        
        // korekce pozice ballModel
        if ballModel.position.y != 0 {
            ballModel.position.y = 0
        }
        
        if ballModel.position.z > 0.158 {
            ballModel.position.z = 0.15
        }
        
        if ballModel.position.z < -0.158 {
            ballModel.position.z = -0.15
        }
        
        if ballModel.position.x > 0.14 {
            ballModel.position.x = 0.13
        }
        
        if ballModel.position.x < -0.139 {
            ballModel.position.x = -0.13
        }
        
        
        // start
        if isPressedStart {
            // uiView.scene.anchors[0].removeChild(ballModel)
            for brick in bricks {
                brick.isEnabled = true
            }
            // uiView.scene.anchors[0].addChild(ballModel)
            
            
            // uiView.scene.anchors[0].addChild(ballModel.clone(recursive: true))
            
            DispatchQueue.main.async {
                ballModel.isEnabled = false
                isPressedStart = false
                isGameOver = false
                score = 0
                ballModel.position = [0, 0, 0]
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                ballModel.isEnabled = true
                
                ballModel.clearForcesAndTorques()
                ballModel.addForce([force/2,0,force/2], relativeTo: ballModel)
            })
        }
    }
}
