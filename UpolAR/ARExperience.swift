//
//  ARExperience.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 19.11.2021.
//

import SwiftUI
import SpriteKit

class GameScene2: SKScene {
    override func didMove(to view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let box = SKSpriteNode(color: SKColor.red, size: CGSize(width: 50, height: 50))
        box.position = location
        box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        addChild(box)
    }
}

struct ARExperience: View {
    @Environment(\.presentationMode) var presentationMode
    
    var scene: SKScene {
        let scene = GameScene2()
        scene.size = CGSize(width: 300, height: 400)
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some View {
        VStack {
            Text("AR Experience")
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("close")
            }
            SpriteView(scene: scene)
                .frame(width: 300, height: 400)
                .ignoresSafeArea()
        }
        
        
    }
    
    
}

struct ARExperience_Previews: PreviewProvider {
    static var previews: some View {
        ARExperience()
    }
}
