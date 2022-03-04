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

struct BreakoutGameAR: UIViewRepresentable {
    
    @Binding var position: Float?
    @Binding var isPressedStart: Bool
    @State var score = 0
    @State var gameState: GameState = .ready
        
    let force: Float = 15
    
    // modely
    var paddleModel = ModelEntity(mesh: MeshResource.generateBox(width: 0.1, height: 0.02, depth: 0.02, cornerRadius: 0.1, splitFaces: false),
                                  materials: [UnlitMaterial(color: .red)])
    var ballModel = ModelEntity(mesh: MeshResource.generateSphere(radius: 0.01),
                                materials: [UnlitMaterial(color: .white)])
    
    // Physics body component
    let kinematicBodyComponent = PhysicsBodyComponent(
        massProperties: PhysicsMassProperties(mass: 2),
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
       
    func makeUIView(context: Context) -> ARView {
            
        let arView = ARView(frame: .zero)
        let anchor = try! BreakoutGameARScene.loadBreakout()
                
        anchor.generateCollisionShapes(recursive: false)
        arView.scene.anchors.append(anchor)

        // podlaha
        let floorModel = makeFloor(arView: arView, anchor: anchor)
        anchor.addChild(floorModel)
        
        // vrchní kryt
        let roofModel = makeRoof()
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
        for column in -1..<2 {
            for row in 0..<6 {
                if !(column != 0 && row < 2) {
                    let brickModel = makeBrick(col: column, row: row, color: UIColor(named: "BlueColor")!)
                    bricks.append(brickModel)
                    anchor.addChild(brickModel)
                }
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
        
        collisionSubscribing = getCollisionSub(arView: arView)
        
        return arView
    }
    
    // MARK: Funkce
    func hitBrick(brick: Entity) {
        print("brick!")
        ballModel.addForce([0,0,force], relativeTo: ballModel)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            brick.isEnabled = false
            var isBrickEnabled = false
            for brick in bricks {
                isBrickEnabled = isBrickEnabled || brick.isEnabled
            }
            score += 1
            print("DEBUG: Score: \(score)")
            if !isBrickEnabled {
                gameState = .winner
            }
        })
    }
    
    func hitBottom() {
        print("bottom!")
        DispatchQueue.main.async {
            ballModel.isEnabled = false
            ballModel.position = [0, 0, 0]
            gameOver()
        }
    }
    
    func gameOver() {
        print("DEBUG: Game over")
        ballModel.isEnabled = false
        gameState = .gameover
    }
    
    func makeBrick(col: Int, row: Int, color: UIColor) -> ModelEntity {
        let brick = MeshResource.generateBox(width: 0.08, height: 0.02, depth: 0.01, cornerRadius: 0, splitFaces: false)
        let brickModel = ModelEntity(mesh: brick, materials: [makeMaterial(color: color)])
        brickModel.components[PhysicsBodyComponent.self] = kinematicBodyComponent
        brickModel.generateCollisionShapes(recursive: false)
        brickModel.position = [Float(col) * 0.09, 0, -0.075 - Float(row) * Float(0.02)]
        brickModel.name = "brick"
        return brickModel
    }
    
    func makeFloor(arView: ARView, anchor: BreakoutGameARScene.Breakout) -> ModelEntity {
        let floor = MeshResource.generatePlane(width: 0.297, depth: 0.420)
        let floorModel = ModelEntity(mesh: floor)
        floorModel.name = "floorModel"
        if let videoURL = Bundle.main.url(forResource: "BreakoutVideoMaterial", withExtension: "mp4") {
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
        return floorModel
    }
    
    func makeRoof() -> ModelEntity {
        let roof = MeshResource.generatePlane(width: 0.297, depth: 0.420)
        let roofModel = ModelEntity(mesh: roof, materials: [transparentMaterial])
        roofModel.components[PhysicsBodyComponent.self] = kinematicBodyComponent
        roofModel.generateCollisionShapes(recursive: false)
        roofModel.position = [0, 0.02, 0]
        return roofModel
    }
    
    func makeMaterial(color: UIColor) -> UnlitMaterial {
        let material = UnlitMaterial(color: color)
        return material
    }
    
    func getCollisionSub(arView: ARView) -> Cancellable? {
        let subscribing = arView.scene.subscribe(to: CollisionEvents.Began.self) { event in
            DispatchQueue.main.async {
                ballModel.clearForcesAndTorques()
            }
            
            if event.entityA == ballModel {
                switch event.entityB.name {
                case "leftModel":
                    ballModel.addForce([force,0,0], relativeTo: ballModel)
                case "rightModel":
                    ballModel.addForce([-1*(force),0,0], relativeTo: ballModel)
                case "topModel":
                    ballModel.addForce([0,0,force], relativeTo: ballModel)
                case "paddleModel":
                    ballModel.addForce([0,0,-1*(force)], relativeTo: ballModel)
                case "bottomModel":
                    hitBottom()
                case "brick":
                    hitBrick(brick: event.entityB)
                default:
                    print("netrefil nic!")
                }
            }
        }
        return subscribing
    }
    
    // MARK: Texty
    func removeText(uiView: ARView) {
        while let oldScore = uiView.scene.anchors[0].findEntity(named: "text") {
                uiView.scene.anchors[0].removeChild(oldScore)
        }
    }
    
    let firstLinePosition: SIMD3<Float> = [-0.07, 0, 0.148]
    let secondLinePosition: SIMD3<Float> = [-0.07, 0, 0.124]
    
    func getSmallTextEntity(text: String, position: SIMD3<Float>) -> ModelEntity {
        let smallFont: MeshResource.Font = .systemFont(ofSize: 0.025, weight: .bold)

        let textEntity = ModelEntity(mesh: .generateText(text, extrusionDepth: 0.001, font: smallFont, containerFrame: CGRect.zero, alignment: .center, lineBreakMode: .byCharWrapping), materials: [makeMaterial(color: UIColor(named: "BlueColor")!)])
        textEntity.name = "text"
        textEntity.transform = Transform(pitch: -(.pi/2), yaw: 0, roll: 0)
        textEntity.position = position
        return textEntity
    }
    
    func getBigTextEntity(text: String) -> ModelEntity {
        let bigFont: MeshResource.Font = .systemFont(ofSize: 0.05, weight: .bold)

        let textEntity = ModelEntity(mesh: .generateText("\(score)", extrusionDepth: 0.001, font: bigFont, containerFrame: CGRect.zero, alignment: .center, lineBreakMode: .byCharWrapping), materials: [makeMaterial(color: UIColor(named: "BlueColor")!)])
        textEntity.name = "text"
        textEntity.transform = Transform(pitch: -(.pi/2), yaw: 0, roll: 0)
        textEntity.position = firstLinePosition
        return textEntity
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // pohyb padle
        if let entityPosition = self.position {
            paddleModel.position = [entityPosition, 0, 0.18]
        }
        
        // změny textů
        if gameState == .play {
            
            // odstranění starého textu
            removeText(uiView: uiView)
            
            if score > 0 {
                let text = getBigTextEntity(text: "\(score)")
                uiView.scene.anchors[0].addChild(text)
            }

        } else if gameState == .winner {
            
            // odstranění balonku
            ballModel.isEnabled = false
            
            // odstranění starého textu
            removeText(uiView: uiView)
            
            let text1 = getSmallTextEntity(text: "WINNER", position: secondLinePosition)
            let text2 = getSmallTextEntity(text: "SCORE: \(score)", position: firstLinePosition)
            uiView.scene.anchors[0].addChild(text1)
            uiView.scene.anchors[0].addChild(text2)
            
        } else if gameState == .gameover {
            
            // pdstranění starého textu
            removeText(uiView: uiView)
            
            let text1 = getSmallTextEntity(text: "GAME", position: secondLinePosition)
            let text2 = getSmallTextEntity(text: "OVER", position: firstLinePosition)
            uiView.scene.anchors[0].addChild(text1)
            uiView.scene.anchors[0].addChild(text2)
        }
        
        // start
        if isPressedStart {
            for brick in bricks {
                brick.isEnabled = true
            }
            removeText(uiView: uiView)
            
            DispatchQueue.main.async {
                ballModel.isEnabled = false
                isPressedStart = false
                gameState = .play
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

enum GameState {
    case ready
    case play
    case winner
    case gameover
}
